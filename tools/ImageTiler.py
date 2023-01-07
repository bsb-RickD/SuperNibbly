from PIL import Image
from ordered_set import OrderedSet

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


def get_unique_colors(img):
    return OrderedSet(img.getdata())


def map_colors_to_index(img, colors, offset=1):
    return tuple(colors.index(d) + offset for d in img.getdata())


def flip_horizontal(tile, ts):
    return tuple(tile[y * ts + x] for y in range(ts) for x in range(ts - 1, -1, -1))


def flip_vertical(tile, ts):
    return tuple(tile[y * ts + x] for y in range(ts - 1, -1, -1) for x in range(ts))


def tile_bytes(tile, bits_per_pixel):
    if bits_per_pixel == 8:
        return tile
    if bits_per_pixel == 4:
        return [(a << 4) + b for a, b in (tile[i:i + 2] for i in range(0, len(tile), 2))]
    if bits_per_pixel == 2:
        return [(a << 6) + (b << 4) + (c << 2) + d for a, b, c, d in (tile[i:i + 4] for i in range(0, len(tile), 4))]


def map_entry_bytes(tile_index, palette_index, h_flip, v_flip):
    return tile_index & 255, (palette_index << 4) + (v_flip << 3) + (h_flip << 2) + (tile_index >> 8)


def append_palette(pal, palette_bytes):
    palette_bytes.append(0)
    palette_bytes.append(0)  # first entry is always 0,0

    for r, g, b in pal:
        palette_bytes.append(((g // 17) << 4) + b // 17)
        palette_bytes.append(r // 17)

    missing_entries = 15 - len(pal)  # palettes can be incomplete
    for i in range(missing_entries):
        palette_bytes.append(0)
        palette_bytes.append(0)


def bytes_as_hex_text(data, bytes_per_line=24):
    p = 0
    output = ""

    while p < len(data):
        output += ".byte " + ",".join(['$' + ('0' + hex(b)[2:])[-2:] for b in data[p:p + bytes_per_line]]) + "\n"
        p += bytes_per_line

    return output


def write_data(data, name: str, write_asm=False):
    """
        Creates a file and writes data to it.
        Optionally can create a second file, with asm source of the data

        :param data: The data to write, as byte arreay or similar, gets iterated
        :param name: name of the file, without extension, the extension .bin / .asm gets added automatically
        :param write_asm: If true, also the asm file is generated
    """

    bin_name = name + ".bin"
    asm_name = name + ".asm"

    with open(bin_name, "wb") as fp:
        fp.write(data)
        # print("### Wrote: " + bin_name)  # for debugging
    if write_asm:
        with open(asm_name, "wt") as fp:
            fp.write(bytes_as_hex_text(data))
            # print("### Wrote: " + asm_name)  # for debugging


def make_filename(name, prefix):
    if prefix is not None and prefix != "":
        return prefix + "_" + name
    return name


def write_palettes(palettes, prefix=""):
    palette_bytes = bytearray()
    for pal in palettes:
        append_palette(pal, palette_bytes)

    write_data(palette_bytes, make_filename("palette", prefix))
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
        tiles_bytes[idx:idx + single_tile_size] = tile_bytes(tile, bits_per_pixel)

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
                s.data = tile_bytes(map_colors_to_index(animframe, colors, 0), 4)
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
    init()
    prefix = "intro"
    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\TITEL_BG_x16.png")
    img = img.convert("RGB")
    size, palettes, screen_buffer_bytes, empty_space_at_end = calc_tiles(img, 8, 16, prefix)

    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm.png")

    make_sprites(img, palettes, ((117, 18), (132, 101)), (1, 6), name="smoke")  # smoke
    make_sprites(img, palettes, ((80, 19), (111, 188)), (1, 17), name="fish")  # fish
    make_sprites(img, palettes, ((1, 19), (32, 210)), (1, 16), name="plane")  # plane

    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\woodly2.png")
    make_sprites(img, palettes, ((1, 1), (51, 84)), (1, 1), name="n")  # N
    make_sprites(img, palettes, ((58, 1), (87, 72)), (1, 1), name="i")  # I
    make_sprites(img, palettes, ((91, 1), (145, 75)), (1, 1), name="b1")  # B
    make_sprites(img, palettes, ((150, 1), (204, 70)), (1, 1), name="b2")  # B
    make_sprites(img, palettes, ((209, 1), (260, 78)), (1, 1), name="l")  # L
    make_sprites(img, palettes, ((264, 1), (315, 82)), (1, 1), name="y")  # Y

    # copy 8x8 sprites into the 48 bytes at the end of each line..
    hide_sprites_in_screen_buffer(screen_buffer_bytes, sprites, empty_space_at_end)
    # neeed to re-write the screen data, after sprites where inserted
    write_data(screen_buffer_bytes, make_filename("screen", prefix))

    write_sprites(sprites, size, prefix)
    write_palettes(palettes, prefix)


def super_nibbly_travel():
    init()
    prefix = "travel"
    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\LMAPP_x16.png")
    transparent_color = tuple(img.getpalette()[0:3])
    img = img.convert("RGB")

    size, palettes, screen_buffer_bytes, empty_space_at_end = calc_tiles(img, 8, 16, prefix, transparent_color)

    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\minanm.png")
    img = img.convert("RGB")

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

    #write_palettes(palettes, prefix)


if __name__ == "__main__":
    # super_nibbly_title()
    super_nibbly_travel()
