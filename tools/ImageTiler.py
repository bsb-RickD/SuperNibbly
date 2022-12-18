from PIL import Image
from ordered_set import OrderedSet

class Sprite:
    def __init__(self):
        self.width = 0
        self.height = 0             # size of sprite
        self.xoffset = 0
        self.yoffset = 0            # offset of upper right corner
        self.data = None            # the actual sprite data
        self.palette_index = 0      # palette frame
        self.frame = 0              # animation frame of the sprite
        self.sprite_id = 0
        self.data_offset = 0        # where in the sprite data block is this sprite located, divided by 32
        self.name = ""


def get_unique_colors(img):
    return OrderedSet(img.getdata())


def map_colors_to_index(img, colors, offset=1):
    return tuple(colors.index(d)+offset for d in img.getdata())


def flip_horizontal(tile, ts):
    return tuple(tile[y*ts+x] for y in range(ts) for x in range(ts-1, -1, -1))


def flip_vertical(tile, ts):
    return tuple(tile[y*ts+x] for y in range(ts-1, -1, -1) for x in range(ts))


def tile_bytes(tile, bits_per_pixel):
    if bits_per_pixel == 8:
        return tile
    if bits_per_pixel == 4:
        return [(a << 4)+b for a, b in (tile[i:i+2] for i in range(0, len(tile), 2))]
    if bits_per_pixel == 2:
        return [(a << 6)+(b << 4)+(c << 2)+d for a, b, c, d in (tile[i:i+4] for i in range(0, len(tile), 4))]


def map_entry_bytes(tile_index, palette_index, h_flip, v_flip):
    return tile_index & 255, (palette_index << 4)+(v_flip << 3)+(h_flip << 2)+(tile_index >> 8)


def append_palette(pal, palette_bytes):
    palette_bytes.append(0)
    palette_bytes.append(0)     # first entry is always 0,0

    for r, g, b in pal:
        palette_bytes.append(((g//17) << 4) + b//17)
        palette_bytes.append(r//17)


def bytes_as_hex_text(data, bytes_per_line=24):
    p = 0
    output = ""

    while p < len(data):
        output += ".byte "+",".join(['$'+('0'+hex(b)[2:])[-2:] for b in data[p:p+bytes_per_line]])+"\n"
        p += bytes_per_line

    return output


def write_data(data, name, write_asm=False):
    with open(name+".bin", "wb") as fp:
        fp.write(data)
    if write_asm:
        with open(name+".asm", "wt") as fp:
            fp.write(bytes_as_hex_text(data))


def write_palettes(palettes):
    palette_bytes = bytearray()
    for pal in palettes:
        append_palette(pal, palette_bytes)

    write_data(palette_bytes, "palette")
    return palette_bytes


def calc_tiles(img, tile_size, max_palette_entries):
    colorcount = {}

    if tile_size != 8 and tile_size != 16:
        raise ValueError("Invalid tile size: %d" % tile_size)

    max_palette_entries -= 1
    if max_palette_entries not in (3, 15, 255):
        raise ValueError("Invalid palette size: %d" % max_palette_entries)

    w, h = img.size

    if w % tile_size != 0 or h % tile_size != 0:
        raise ValueError("Image size needs to be dividable by %d - got %d x %d" % (tile_size, w, h))

    # list if (palette, [subimage])
    palettes_plus_subimages = []

    for y in range(0, h, tile_size):
        for x in range(0, w, tile_size):
            subimage = img.crop((x, y, x+tile_size, y+tile_size))
            subimage_xy = (subimage, x//tile_size, y//tile_size)

            pal = get_unique_colors(subimage)
            if len(pal) > max_palette_entries:
                print("found tile with %d colors" % len(pal))

            if len(pal) not in colorcount:
                colorcount[len(pal)] = 0
            colorcount[len(pal)] += 1

            for p, tiles in palettes_plus_subimages:
                if pal.issubset(p):                             # is the new palette part of an existing one?
                    tiles.append(subimage_xy)
                    break
                combined = p.union(pal)
                if len(combined) <= max_palette_entries:        # can we combine the colors to a new palette of
                    tiles.append(subimage_xy)
                    p.update(pal)
                    break
            else:
                palettes_plus_subimages.append((pal, [subimage_xy]))

    tile_count = 0
    tiles = {}
    stride = (w//tile_size)
    tiled_image = [None]*(stride*h//tile_size)

    for pal_index, (pal, subimages) in enumerate(palettes_plus_subimages):
        colors = list(pal)
        for si, x, y in subimages:
            tile = map_colors_to_index(si, colors)
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
            tile_position = y*stride+x
            if tiled_image[tile_position] is None:
                tiled_image[tile_position] = (tile_index, pal_index, flipped_h, flipped_v)
            else:
                raise ValueError("tile spot already taken? (%d,%d)" % (x, y))

    num_tiles = len(tiles)
    bits_per_pixel = {3: 2, 15: 4, 255: 8}.get(max_palette_entries)
    tile_byte_count = num_tiles*(tile_size*tile_size)//(8//bits_per_pixel)

    single_tile_size = (tile_size*tile_size*bits_per_pixel)//8
    tiles_bytes = bytearray(tile_byte_count)
    for tile, index in tiles.items():
        idx = index*single_tile_size
        tiles_bytes[idx:idx+single_tile_size] = tile_bytes(tile, bits_per_pixel)

    write_data(tiles_bytes, "tiles")

    print("== Config: %d x %d tiles of %d colors ===================" % (tile_size, tile_size, max_palette_entries+1))
    num_palettes = len(palettes_plus_subimages)

    palettes = [pal for pal, _ in palettes_plus_subimages]
    palette_bytes = write_palettes(palettes)
    palette_byte_count = len(palette_bytes)

    write_data(palette_bytes, "palette")

    print("Palettes: %d\t%d Bytes" % (num_palettes, palette_byte_count))

    print("Tiles: %d\t%d Bytes" % (num_tiles, tile_byte_count))

    print ("color / num tiles: ", colorcount)

    screen_columns = 32
    while (screen_columns*tile_size) < w:
        screen_columns *= 2
    screen_rows = h//tile_size
    screen_buffer_size = screen_columns*screen_rows*2
    screen_buffer_bytes = bytearray(screen_buffer_size)

    idx = 0
    tidx = 0
    for y in range(h//tile_size):
        for x in range(w//tile_size):
            screen_buffer_bytes[tidx*2:tidx*2+2] = map_entry_bytes(*tiled_image[idx])
            idx += 1
            tidx += 1
        tidx += screen_columns-(w//tile_size)

    write_data(screen_buffer_bytes, "screen")

    print("Screen:\t\t%d Bytes (%dx%d)" % (screen_buffer_size, screen_columns, screen_rows))

    total = palette_byte_count+tile_byte_count+screen_buffer_size
    print("Total:\t\t%d Bytes  (%f kB)\n\n" % (total, total/1024))

    return screen_buffer_size+tile_byte_count, palettes


def get_bounding_box(img, transparent_color):
    w, h = img.size

    uy = 0
    while uy < h:
        rx = 0
        for rx in range(w):
            if img.getpixel((rx, uy)) != transparent_color:
                break
        if rx != w-1:
            break
        uy += 1

    if uy == h:
        return None

    ly = h
    while ly > 0:
        rx = 0
        for rx in range(w):
            if img.getpixel((rx, ly-1)) != transparent_color:
                break
        if rx != w-1:
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
            if img.getpixel((rx-1, cy)) != transparent_color:
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


sprites = []
total_sprite_size = 0


def make_sprites(img, palettes, rect, frames=(1, 1), transparent_pixel=None, name=""):
    global total_sprite_size

    if transparent_pixel is None:
        transparent_pixel = rect[0]

    transparent_color = img.getpixel(transparent_pixel)
    subimage = img.crop((rect[0][0], rect[0][1], rect[1][0]+1, rect[1][1]+1))
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
                break;
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
            animframe = subimage.crop((tx, ty, tx+frame_w, ty+frame_h))
            bbox = get_bounding_box(animframe, transparent_color)
            if bbox is not None:
                animframe = pad_to_next_size(animframe.crop(bbox), transparent_color)
                # animframe.show() # for debugging
                s = Sprite()
                s.width, s.height = animframe.size
                s.xoffset = bbox[0]
                s.yoffset = bbox[1]
                s.frame = framecount
                s.palette_index = palindex
                s.data = tile_bytes(map_colors_to_index(animframe, colors, 0), 4)
                s.data_offset = total_sprite_size//32
                s.name = name
                sprites.append(s)
                total_sprite_size += len(s.data)
                framecount += 1

    write_palettes(palettes)


def write_sprites(sprites, baseaddress):
    sprite_data = bytearray()
    for sprite in sprites:
        sprite_data += bytearray(sprite.data)

    write_data(sprite_data, "sprites")

    bp = baseaddress // 32
    with open("sprites" + ".inc", "wt") as fp:
        for sprite in sprites:
            fp.write("; Sprite %s, frame %d\n" % (sprite.name, sprite.frame))
            fp.write("sprite_%s_%d:\n" % (sprite.name, sprite.frame))
            fp.write(".byte %d, %d\t; x- and y-offset\n" % (sprite.xoffset, sprite.yoffset))
            mode = 0 # 16 color - need to change for 256 colors
            address = bp+sprite.data_offset+(mode<<7)
            fp.write(".word %d\t; address/32 (+ 16/256 bit as MSB)\n" % address)
            fp.write(".word 0, 0\t; x,y pos\n")
            fp.write(".byte %d\t; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip\n" % (3 << 2))
            fp.write(".byte VERA_sprite_height_%d+VERA_sprite_width_%d+%d\t;h, w, palette index\n\n" % (sprite.height, sprite.width, sprite.palette_index))



def main():
    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_LBM_Files\titel_bg.png")
    img = img.convert("RGB")
    size, palettes = calc_tiles(img, 8, 16)
    print(palettes)

    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm.png")

    make_sprites(img, palettes, ((117, 18), (132, 101)), (1, 6), name="smoke")  # smoke
    make_sprites (img, palettes, ((80,19),(111,188)),(1,17), name="fish")  # fish
    make_sprites(img, palettes, ((1, 19), (32, 210)), (1, 16), name="plane")  # plane

    write_sprites(sprites, size)

    # calc_tiles(img, 8, 256)
    # calc_tiles(img, 16, 16)
    # calc_tiles(b+++bbimg, 16, 256)


if __name__ == "__main__":
    main()