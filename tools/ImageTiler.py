from ImageUtils import get_sub_images, write_data, map_colors_to_index, image_bytes, flip_horizontal, \
    flip_vertical, print_header, create_screen_buffer_entry
from Sprites import SpriteGroup


def make_filename(name, prefix):
    if prefix is not None and prefix != "":
        return prefix + "_" + name
    return name


class ImageTiler:
    def __init__(self, image, transparency, tile_size=8, max_palette_entries=16):
        if tile_size != 8 and tile_size != 16:
            raise ValueError("Invalid tile size: %d" % tile_size)

        max_palette_entries -= 1
        if max_palette_entries not in (3, 15, 255):
            raise ValueError("Invalid palette size: %d" % max_palette_entries)

        w, h = image.size

        if w % tile_size != 0 or h % tile_size != 0:
            raise ValueError("Image size needs to be dividable by %d - got %d x %d" % (tile_size, w, h))

        self.width = w
        self.height = h
        self.tile_size = tile_size
        self.max_palette_entries = max_palette_entries
        self.sub_images = [si for si in get_sub_images(image, (0, 0), (w - 1, h - 1), (w / 8, h / 8), transparency,
                                                       max_palette_size=max_palette_entries)]
        self.tiles_bytes = bytearray()
        self.screen_buffer_bytes = bytearray()

        # for hiding sprites in the screen buffer bytes
        self.empty_space_at_end_of_each_line = 0
        self.empty_space_at_end = 0
        self.line_spot = 0
        self.stride = 0

    def palettes(self):
        return (s.palette for s in self.sub_images)

    def calc_tiles(self, palette_optimizer):
        tile_count = 0
        tiles = {}
        stride = (self.width // self.tile_size)
        tiled_image = [None] * (stride * (self.height // self.tile_size))

        for si in self.sub_images:
            pal_index, pal = palette_optimizer.get_index(si.palette)
            colors = list(pal)
            if si.transparent_color is not None:
                colors.insert(0, si.transparent_color)

            tile = map_colors_to_index(si.img, colors, 0 if si.transparent_color is not None else 1)
            flipped_h = 0
            flipped_v = 0
            if tile in tiles:
                tile_index = tiles[tile]
            else:
                fh = flip_horizontal(tile, self.tile_size)
                if fh in tiles:
                    flipped_h = 1
                    tile_index = tiles[fh]
                else:
                    fv = flip_vertical(tile, self.tile_size)
                    if fv in tiles:
                        flipped_v = 1
                        tile_index = tiles[fv]
                    else:
                        fhv = flip_vertical(fh, self.tile_size)
                        if fhv in tiles:
                            flipped_h = 1
                            flipped_v = 1
                            tile_index = tiles[fhv]
                        else:
                            tile_index = tile_count
                            tile_count += 1
                            tiles[tile] = tile_index
            tile_position = si.index
            if tiled_image[tile_position] is None:
                tiled_image[tile_position] = (tile_index, pal_index, flipped_h, flipped_v)
            else:
                raise ValueError("tile spot already taken? (%d - %d/%d)" % (si.index, si.x, si.y))

        num_tiles = len(tiles)
        bits_per_pixel = {3: 2, 15: 4, 255: 8}.get(self.max_palette_entries)
        tile_byte_count = num_tiles * (self.tile_size * self.tile_size) // (8 // bits_per_pixel)

        single_tile_size = (self.tile_size * self.tile_size * bits_per_pixel) // 8
        self.tiles_bytes = bytearray(tile_byte_count)
        for tile, index in tiles.items():
            idx = index * single_tile_size
            self.tiles_bytes[idx:idx + single_tile_size] = image_bytes(tile, bits_per_pixel)

        print_header("Image Tiler Config: %d x %d tiles of %d colors" %
                     (self.tile_size, self.tile_size, self.max_palette_entries + 1))

        print("Tiles:\t\t%d Bytes (%d tiles)" % (tile_byte_count, num_tiles))

        screen_columns = 32
        while (screen_columns * self.tile_size) < self.width:
            screen_columns *= 2
        screen_rows = self.height // self.tile_size
        self.stride = screen_columns * 2
        pay_load_length = int(self.width // self.tile_size) * 2
        if pay_load_length % 32 != 0:
            pay_load_length = (int(pay_load_length // 32) + 1) * 32
        self.line_spot = pay_load_length
        self.empty_space_at_end_of_each_line = self.stride - pay_load_length
        screen_buffer_size = self.stride * screen_rows

        # pad screen buffer to a multiple of 2048 (for the tile base)
        tilebase_chunk_size = 2048
        screen_chunk_remainder = screen_buffer_size % tilebase_chunk_size
        empty_space_at_end = 0
        if screen_chunk_remainder != 0:
            empty_space_at_end = tilebase_chunk_size - screen_chunk_remainder
        screen_buffer_size += empty_space_at_end
        self.empty_space_at_end = empty_space_at_end

        # init it all to zero, just to be safe
        self.screen_buffer_bytes = (bytearray(b'\x00')) * screen_buffer_size

        idx = 0
        tidx = 0
        for y in range(self.height // self.tile_size):
            for x in range(self.width // self.tile_size):
                self.screen_buffer_bytes[tidx * 2:tidx * 2 + 2] = create_screen_buffer_entry(*tiled_image[idx])
                idx += 1
                tidx += 1
            tidx += screen_columns - (self.width // self.tile_size)

        print("Screen:\t\t%d Bytes (%dx%d)" % (screen_buffer_size, screen_columns, screen_rows))

        total = tile_byte_count + screen_buffer_size
        print("Total:\t\t%d Bytes  (%f kB)\n" % (total, total / 1024))

    def save(self, filename):
        write_data(self.tiles_bytes, make_filename("tiles", filename))
        write_data(self.screen_buffer_bytes, make_filename("screen", filename))

    def get_used_memory(self):
        return len(self.tiles_bytes) + len(self.screen_buffer_bytes)

    def hide_sprites_in_screen_buffer(self, sprites_to_potentially_hide: SpriteGroup):
        print_header("Sprite hiding")

        saved = 0
        saved_count = 0

        for sprite in sprites_to_potentially_hide.sprite_bitmaps:
            ss = len(sprite.data)
            sprite.data_offset -= (saved // 32)
            if ss <= self.empty_space_at_end_of_each_line or ss <= self.empty_space_at_end:
                saved += ss
                saved_count += 1
                if ss <= self.empty_space_at_end_of_each_line:
                    # hide in the remainder of the line
                    spot = self.line_spot
                    self.line_spot += self.stride
                else:
                    # hide in the chunk size at the end
                    spot = len(self.screen_buffer_bytes) - self.empty_space_at_end
                    self.empty_space_at_end -= ss
                self.screen_buffer_bytes[spot:spot + ss] = sprite.data
                sprite.data = bytearray()
                sprite.data_offset = spot // 32

            if self.line_spot >= len(self.screen_buffer_bytes):
                break
        print("Could re-use %d bytes (from %d sprites) of screen space!" % (saved, saved_count))

        # we saved sprites, need to update the sprite_data
        if saved_count > 0:
            sprites_to_potentially_hide.get_sprite_data()
