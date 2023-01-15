from PIL import Image
from ordered_set import OrderedSet
from PaletteOptimizer import transparent_color, \
    get_min_num_of_palettes, no_transparent_color, PaletteOptimizer
from ImageUtils import get_unique_colors, get_sub_images, write_data, map_colors_to_index, image_bytes, flip_horizontal, \
    flip_vertical, append_palette, print_header, load_image
from Sprites import SpriteGroup, MultiSprite, Sprite
import Sprites

sprites = []
total_sprite_size = 0


class Sprite:
    def __init__(self):
        self.width = 0
        self.height = 0  # size of sprite
        self.xoffset = 0
        self.yoffset = 0  # offset of upper right corner
        self.data = None  # the actual sprite data
        self.palette_index = 0  # palette frame
        self.frame = 0  # animation frame of the sprite
        self.sprite_id = 0
        self.data_offset = 0  # where in the sprite data block is this sprite located, divided by 32
        self.name = ""


def map_entry_bytes(tile_index, palette_index, h_flip, v_flip):
    return tile_index & 255, (palette_index << 4) + (v_flip << 3) + (h_flip << 2) + (tile_index >> 8)


def make_filename(name, prefix):
    if prefix is not None and prefix != "":
        return prefix + "_" + name
    return name


def write_palettes(palettes, prefix="", write_asm=False):
    palette_bytes = bytearray()
    for pal in palettes:
        append_palette(pal, palette_bytes)

    write_data(palette_bytes, make_filename("palette", prefix), write_asm=write_asm)
    return palette_bytes


def reduce_palettes(palettes):
    done = False
    while not done:
        overlap = sorted(
            [(len(a.intersection(b)), ai, bi) for ai, a in enumerate(palettes) for bi, b in enumerate(palettes)
             if ai != bi and len(a.union(b)) <= 15], key=lambda x: x[0], reverse=True)
        if len(overlap):
            o, i, j = overlap[0]
            a = palettes[i]
            b = palettes[j]
            palettes.remove(a)
            palettes.remove(b)
            palettes.append(a.union(b))
        else:
            done = True
    return palettes


class ImageTiler:
    def __init__(self, image, transparency, tile_size = 8, max_palette_entries = 16):
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
        self.sub_images = [si for si in get_sub_images(image, (0, 0), (w - 1, h - 1), (w / 8, h / 8), transparency(),
                                         max_palette_size=max_palette_entries)]
        self.tiles_bytes = bytearray()
        self.screen_buffer_bytes = bytearray()

        # for hiding sprites in the screen buffer bytes
        self.empty_space_at_end_of_each_line = 0
        self.empty_space_at_end = 0
        self.line_spot = 0

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
            if transparent_color is not None:
                colors.insert(0, transparent_color)

            tile = map_colors_to_index(si.img, colors, 0 if transparent_color is not None else 1)
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
        pay_load_length = int(self.width//self.tile_size)*2
        if pay_load_length % 32 != 0:
            pay_load_length = (int(pay_load_length // 32)+1)*32
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
                self.screen_buffer_bytes[tidx * 2:tidx * 2 + 2] = map_entry_bytes(*tiled_image[idx])
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
        return len(self.tiles_bytes)+len(self.screen_buffer_bytes)

    def hide_sprites_in_screen_buffer(self, sprites_to_potentially_hide):
        saved = 0
        saved_count = 0

        for sprite in sprites_to_potentially_hide:
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
        print_header("Sprite hiding")
        print("Could re-use %d bytes (from %d sprites) of screen space!" % (saved, saved_count))



def calc_tiles(img, tile_size, max_palette_entries, prefix="", transparent_color=None):
    colorcount = {}

    if tile_size != 8 and tile_size != 16:
        raise ValueError("Invalid tile size: %d" % tile_size)

    max_palette_entries -= 1
    if max_palette_entries not in (3, 15, 255):
        raise ValueError("Invalid palette size: %d" % max_palette_entries)

    w, h = img.size

    if w % tile_size != 0 or h % tile_size != 0:
        raise ValueError("Image size needs to be dividable by %d - got %d x %d" % (tile_size, w, h))

    # get all palettes from the sub images and optimize them to a minimum
    all_palettes = []
    for y in range(0, h, tile_size):
        for x in range(0, w, tile_size):
            subimage = img.crop((x, y, x + tile_size, y + tile_size))

            pal = get_unique_colors(subimage)
            if transparent_color in pal:
                pal.remove(transparent_color)
            if len(pal) > max_palette_entries:
                print("found tile with %d colors" % len(pal))
                return

            for p in all_palettes:
                if pal.issubset(p):
                    break
            else:
                to_remove = []
                for index, p in enumerate(all_palettes):
                    if p.issubset(pal):
                        to_remove.append(index)
                for i in reversed(to_remove):
                    all_palettes.remove(all_palettes[i])
                all_palettes.append(set(pal))

    all_palettes = reduce_palettes(all_palettes)

    # list if (palette, [subimage])
    palettes_plus_subimages = [(OrderedSet(p), []) for p in all_palettes]
    for y in range(0, h, tile_size):
        for x in range(0, w, tile_size):
            subimage = img.crop((x, y, x + tile_size, y + tile_size))
            subimage_xy = (subimage, x // tile_size, y // tile_size)

            pal = get_unique_colors(subimage)
            if transparent_color in pal:
                pal.remove(transparent_color)

            if len(pal) not in colorcount:
                colorcount[len(pal)] = 0
            colorcount[len(pal)] += 1

            for p, tiles in palettes_plus_subimages:
                if pal.issubset(p):  # is the new palette part of an existing one?
                    tiles.append(subimage_xy)
                    break
            else:
                raise ValueError("Palette not found?! %s missing in %s" % (pal, all_palettes))

    tile_count = 0
    tiles = {}
    stride = (w // tile_size)
    tiled_image = [None] * (stride * h // tile_size)

    for pal_index, (pal, subimages) in enumerate(palettes_plus_subimages):
        colors = list(pal)
        if transparent_color is not None:
            colors.insert(0, transparent_color)

        for si, x, y in subimages:
            tile = map_colors_to_index(si, colors, 0 if transparent_color is not None else 1)
            flipped_h = 0
            flipped_v = 0
            if tile in tiles:
                tile_index = tiles[tile]
            else:
                fh = flip_horizontal(tile, tile_size)
                if fh in tiles:
                    flipped_h = 1
                    tile_index = tiles[fh]
                else:
                    fv = flip_vertical(tile, tile_size)
                    if fv in tiles:
                        flipped_v = 1
                        tile_index = tiles[fv]
                    else:
                        fhv = flip_vertical(fh, tile_size)
                        if fhv in tiles:
                            flipped_h = 1
                            flipped_v = 1
                            tile_index = tiles[fhv]
                        else:
                            tile_index = tile_count
                            tile_count += 1
                            tiles[tile] = tile_index
            tile_position = y * stride + x
            if tiled_image[tile_position] is None:
                tiled_image[tile_position] = (tile_index, pal_index, flipped_h, flipped_v)
            else:
                raise ValueError("tile spot already taken? (%d,%d)" % (x, y))

    small_tiles = 0
    for tile, tile_index in tiles.items():
        if len(set(tile)) < 4:
            small_tiles += 1

    num_tiles = len(tiles)
    bits_per_pixel = {3: 2, 15: 4, 255: 8}.get(max_palette_entries)
    tile_byte_count = num_tiles * (tile_size * tile_size) // (8 // bits_per_pixel)

    # print("total # tiles: %d (holding %d small tiles)" % (num_tiles, small_tiles))

    single_tile_size = (tile_size * tile_size * bits_per_pixel) // 8
    tiles_bytes = bytearray(tile_byte_count)
    for tile, index in tiles.items():
        idx = index * single_tile_size
        tiles_bytes[idx:idx + single_tile_size] = image_bytes(tile, bits_per_pixel)

    write_data(tiles_bytes, make_filename("tiles", prefix))

    print("== Config: %s - %d x %d tiles of %d colors ===================" %
          (prefix, tile_size, tile_size, max_palette_entries + 1))
    num_palettes = len(palettes_plus_subimages)

    palettes = [pal for pal, _ in palettes_plus_subimages]
    palette_bytes = write_palettes(palettes, prefix)
    palette_byte_count = len(palette_bytes)

    write_data(palette_bytes, make_filename("palette", prefix))

    print("Palettes: %d\t%d Bytes" % (num_palettes, palette_byte_count))

    print("Tiles: %d\t%d Bytes" % (num_tiles, tile_byte_count))

    print("color / num tiles: ", colorcount)

    screen_columns = 32
    while (screen_columns * tile_size) < w:
        screen_columns *= 2
    screen_rows = h // tile_size
    screen_buffer_size = screen_columns * screen_rows * 2

    # pad screen buffer to a multiple of 2048 (for the tile base)
    tilebase_chunk_size = 2048
    screen_chunk_remainder = screen_buffer_size % tilebase_chunk_size
    empty_space_at_end = 0
    if screen_chunk_remainder != 0:
        empty_space_at_end = tilebase_chunk_size - screen_chunk_remainder
    screen_buffer_size += empty_space_at_end

    # init it all to zero, just to be safe
    screen_buffer_bytes = (bytearray(b'\x00')) * screen_buffer_size

    idx = 0
    tidx = 0
    for y in range(h // tile_size):
        for x in range(w // tile_size):
            screen_buffer_bytes[tidx * 2:tidx * 2 + 2] = map_entry_bytes(*tiled_image[idx])
            idx += 1
            tidx += 1
        tidx += screen_columns - (w // tile_size)

    write_data(screen_buffer_bytes, make_filename("screen", prefix))

    print("Screen:\t\t%d Bytes (%dx%d)" % (screen_buffer_size, screen_columns, screen_rows))

    total = palette_byte_count + tile_byte_count + screen_buffer_size
    print("Total:\t\t%d Bytes  (%f kB)\n\n" % (total, total / 1024))

    return screen_buffer_size + tile_byte_count, palettes, screen_buffer_bytes, empty_space_at_end


def get_bounding_box(img, transparent_color):
    w, h = img.size

    uy = 0
    while uy < h:
        rx = 0
        for rx in range(w):
            if img.getpixel((rx, uy)) != transparent_color:
                break
        if rx != w - 1:
            break
        uy += 1

    if uy == h:
        return None

    ly = h
    while ly > 0:
        rx = 0
        for rx in range(w):
            if img.getpixel((rx, ly - 1)) != transparent_color:
                break
        if rx != w - 1:
            break
        ly -= 1

    lx = 0
    while lx < w:
        cy = 0
        for cy in range(h):
            if img.getpixel((lx, cy)) != transparent_color:
                break
        if cy != h - 1:
            break
        lx += 1

    rx = w
    while rx > 0:
        cy = 0
        for cy in range(h):
            if img.getpixel((rx - 1, cy)) != transparent_color:
                break
        if cy != h - 1:
            break
        rx -= 1

    return lx, uy, rx, ly


def get_next_bigger_match(size):
    for c in (8, 16, 32, 64):
        if size <= c:
            return c
    return size


def pad_to_next_size(img, transparent_color):
    w, h = img.size
    ws = get_next_bigger_match(w)
    hs = get_next_bigger_match(h)
    if ws != w or hs != h:
        new_img = Image.new(img.mode, (ws, hs), transparent_color)
        new_img.paste(img, (0, 0))
        return new_img
    return img


def make_sprites(img, palettes, rect, frames=(1, 1), transparent_pixel=None, name="", optimize_size=True):
    if transparent_pixel is None:
        transparent_pixel = rect[0]

    rx = rect[0][0]
    ry = rect[0][1]

    transparent_color = img.getpixel(transparent_pixel)
    w = rect[1][0] - rx + 1
    h = rect[1][1] - ry + 1

    # this needs cleaning up - animations of oversize sprites won't work
    if frames == (1, 1):
        part = 0
        for y in range(0, h, 64):
            sh = min(h - y, 64)
            for x in range(0, w, 64):
                sw = min(w - x, 64)
                srect = ((rx + x, ry + y), (rx + x + sw - 1, ry + y + sh - 1))
                soff = (x, y)
                make_sprites_internal(img, palettes, srect, frames, transparent_color, "%s_%d" % (name, part), soff)
                part += 1
    else:
        make_sprites_internal(img, palettes, rect, frames, transparent_color, name, (0, 0), optimize_size)


def make_sprites_internal(img, palettes, rect, frames, transparent_color, name, sprite_offset, optimize_size=True):
    global total_sprite_size

    subimage = img.crop((rect[0][0], rect[0][1], rect[1][0] + 1, rect[1][1] + 1))
    w, h = subimage.size

    spritepal = get_unique_colors(subimage)
    if transparent_color in spritepal:
        spritepal.remove(transparent_color)

    for index, pal in enumerate(palettes):
        if pal.issuperset(spritepal):
            palindex = index
            break
    else:
        # no pal found.. let's see if we can find one where we can merge our colors into..
        for index, pal in enumerate(palettes):
            candidate = pal.union(spritepal)
            if len(candidate) <= 15:
                palettes[index] = candidate
                palindex = index
                break
        else:
            # no pal with room found, creare a new one
            palindex = len(palettes)
            palettes.append(spritepal)

    colors = list(palettes[palindex])
    colors.insert(0, transparent_color)

    if (w % frames[0] != 0) or (h % frames[1] != 0):
        raise ValueError("Sprite-subimage size not a multiple of (%d x %d)" % frames)

    frame_w = w // frames[0]
    frame_h = h // frames[1]

    framecount = 0

    for ty in range(0, h, frame_h):
        for tx in range(0, w, frame_w):
            animframe = subimage.crop((tx, ty, tx + frame_w, ty + frame_h))
            if optimize_size:
                bbox = get_bounding_box(animframe, transparent_color)
            else:
                bbox = (0, 0, frame_w, frame_h)
            if bbox is not None:
                animframe = pad_to_next_size(animframe.crop(bbox), transparent_color)
                # animframe.show() # for debugging
                s = Sprite()
                s.width, s.height = animframe.size
                s.xoffset = bbox[0] + sprite_offset[0]
                s.yoffset = bbox[1] + sprite_offset[1]
                s.frame = framecount
                s.palette_index = palindex
                s.data = image_bytes(map_colors_to_index(animframe, colors, 0), 4)
                s.data_offset = total_sprite_size // 32
                s.name = name
                sprites.append(s)
                total_sprite_size += len(s.data)
                framecount += 1


def write_sprites(sprites_to_write, baseaddress, prefix=None):
    sprite_data = bytearray()
    for sprite in sprites_to_write:
        sprite_data += bytearray(sprite.data)

    filename = make_filename("sprites", prefix)

    write_data(sprite_data, filename)

    bp = baseaddress // 32
    with open(filename + ".inc", "wt") as fp:
        for sprite in sprites:
            # watch out - for hidden sprites len(sprite.data) = 0
            sprite_size = len(sprite.data)
            sprite_colors = 256 if sprite.width * sprite.height == sprite_size else 16
            fp.write("; Sprite %s, frame %d (%dx%d - %d colors)\n" %
                     (sprite.name, sprite.frame, sprite.width, sprite.height, sprite_colors))
            fp.write("sprite_%s_%d:\n" % (sprite.name, sprite.frame))
            fp.write(".byte %d, %d\t; x- and y-offset\n" % (sprite.xoffset, sprite.yoffset))

            address = sprite.data_offset  # hidden sprites know their address
            if sprite_size != 0:
                address += bp  # others need to add the base pointer first

            fp.write(".word %d+VERA_sprite_colors_%d\t; address/32 (+ color indicator) \n" % (address, sprite_colors))
            fp.write(".word 0, 0\t; x,y pos\n")
            fp.write(".byte %d\t; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip\n" % (3 << 2))
            fp.write(".byte VERA_sprite_height_%d+VERA_sprite_width_%d+%d\t;h, w, palette index\n\n" %
                     (sprite.height, sprite.width, sprite.palette_index))


def hide_sprites_in_screen_buffer(buffer_bytes, sprites_to_potentially_hide, empty_space_at_end):
    lines = 240
    stride = 128
    current_spot = 96
    sprite_max_size = 32

    saved = 0
    saved_count = 0

    line = 0
    for sprite in sprites_to_potentially_hide:
        ss = len(sprite.data)
        sprite.data_offset -= (saved // 32)
        if ss <= sprite_max_size or ss <= empty_space_at_end:
            saved += ss
            saved_count += 1
            if ss <= sprite_max_size:
                # hide in the remainder of the line
                spot = current_spot
                current_spot += stride
            else:
                # hide in the chunk size at the end
                spot = len(buffer_bytes) - empty_space_at_end
                empty_space_at_end -= ss
            buffer_bytes[spot:spot + ss] = sprite.data
            sprite.data = bytearray()
            sprite.data_offset = spot // 32

        line += 1
        if line >= lines:
            break

    print("Could re-use %d bytes (from %d sprites) of screen space!" % (saved, saved_count))


def init():
    global sprites
    global total_sprite_size

    sprites = []
    total_sprite_size = 0


def super_nibbly_title():
    title = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\TITEL_BG_x16.png")
    titanm = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm.png")
    woodly2 = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\woodly2.png")

    # define the sprites
    sg = SpriteGroup([
        MultiSprite(titanm, (117, 18), (132, 101), (1, 6), name="smoke"),
        MultiSprite(titanm, (80, 19), (111, 188), (1, 17), name="fish"),
        MultiSprite(titanm, (1, 19), (32, 210), (1, 16), name="plane"),
        Sprites.Sprite(woodly2, (1, 1), (51, 84), name="n"),
        Sprites.Sprite(woodly2, (58, 1), (87, 72), name="i"),
        Sprites.Sprite(woodly2, (91, 1), (145, 75), name="b1"),
        Sprites.Sprite(woodly2, (150, 1), (204, 70), name="b2"),
        Sprites.Sprite(woodly2, (209, 1), (260, 78), name="l"),
        Sprites.Sprite(woodly2, (264, 1), (315, 82), name="y"),
    ])

    # background image
    it = ImageTiler(title, no_transparent_color)

    # optimize palette
    po = PaletteOptimizer(it,sg)

    # use optimized palette for tiles and sprites
    it.calc_tiles(po)
    sg.calc_sprite_bitmaps(po, it.get_used_memory())

    # save some space on sprites
    it.hide_sprites_in_screen_buffer(sg.sprite_bitmaps)

    # write everything to disk
    sg.save("intro_sprites")
    po.save("intro_palette")
    it.save("intro")


def super_nibbly_travel():
    init()
    prefix = "travel"
    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\LMAPP_x16.png")
    transparent_color = tuple(img.getpalette()[0:3])
    img = img.convert("RGB")

    size, palettes, screen_buffer_bytes, empty_space_at_end = calc_tiles(img, 8, 16, prefix, transparent_color)

    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\minanm.png")
    img = img.convert("RGB")

    make_sprites(img, palettes, ((246, 32), (293, 231)), (1, 10), name="speech_big")
    make_sprites(img, palettes, ((214, 32), (237, 151)), (1, 6), name="speech_medium")
    make_sprites(img, palettes, ((214, 14), (261, 30)), (2, 1), name="speech_small")
    write_sprites(sprites, size, prefix + "_common")

    size += total_sprite_size

    y_start = 0
    landscapes = ["green", "ice", "vulcano", "desert"]

    for i in range(4):
        init()
        make_sprites(img, palettes, ((0, 80 + y_start), (95, 103 + y_start)), (3, 1),
                     name="mountain_bg", optimize_size=False)
        make_sprites(img, palettes, ((0, 104 + y_start), (95, 111 + y_start)), (3, 1),
                     name="mountain_fg", optimize_size=False)
        make_sprites(img, palettes, ((104, 88 + y_start), (135, 111 + y_start)), (2, 1),
                     name="trees", optimize_size=False)
        make_sprites(img, palettes, ((136, 80 + y_start), (183, 111 + y_start)), (2, 1),
                     name="houses", optimize_size=False)
        y_start += 32
        write_sprites(sprites, size, prefix + "_" + landscapes[i])

    write_palettes(palettes, prefix, write_asm=True)


def test_palette_optimization():
    bg_img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\LMAPP_x16.png")
    bg_img = bg_img.convert("RGB")
    w, h = bg_img.size

    pal_generators = [get_palettes_from_images(get_sub_images(bg_img, (0, 0), (w - 1, h - 1), (w / 8, h / 8)),
                                               transparent_color((255, 0, 0)))]

    spr_img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\minanm.png")
    spr_img = spr_img.convert("RGB")

    sprite_groups = [SpriteGroup("travel_common_sprites", [
        Sprites(spr_img, (246, 32), (293, 231), (1, 10), name="speech_big"),
        Sprites(spr_img, (214, 32), (237, 151), (1, 6), name="speech_medium"),
        Sprites(spr_img, (214, 14), (261, 30), (2, 1), name="speech_small")])]

    y_start = 0
    landscapes = ["green", "ice", "vulcano", "desert"]

    for i in range(4):
        sprite_groups.append(SpriteGroup("travel_" + landscapes[i]+"_sprites", [
            Sprites(spr_img, (0, 80 + y_start), (95, 103 + y_start), (3, 1), name="mountain_bg", optimize_size=False),
            Sprites(spr_img, (0, 104 + y_start), (95, 111 + y_start), (3, 1), name="mountain_fg", optimize_size=False),
            Sprites(spr_img, (104, 88 + y_start), (135, 111 + y_start), (2, 1), name="trees", optimize_size=False),
            Sprites(spr_img, (136, 80 + y_start), (183, 111 + y_start), (2, 1), name="houses", optimize_size=False)]))
        y_start += 32

    for sg in sprite_groups:
        pal_generators.append(sg.palettes())
    optimal_palettes = get_min_num_of_palettes(*pal_generators)


if __name__ == "__main__":
    super_nibbly_title()
    # super_nibbly_travel()
    # test_palette_optimization()
