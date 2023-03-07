from PIL import Image
import numpy as np
from ordered_set import OrderedSet


def get_unique_colors(img):
    return OrderedSet(img.getdata())


def map_colors_to_index(img, colors, offset=1):
    return tuple(colors.index(d) + offset for d in img.getdata())


def image_bytes(img, bits_per_pixel):
    if bits_per_pixel == 8:
        return img
    if bits_per_pixel == 4:
        return [(a << 4) + b for a, b in (img[i:i + 2] for i in range(0, len(img), 2))]
    if bits_per_pixel == 2:
        return [(a << 6) + (b << 4) + (c << 2) + d for a, b, c, d in (img[i:i + 4] for i in range(0, len(img), 4))]


def image_bytes_to_index(img_bytes, bits_per_pixel):
    if bits_per_pixel == 8:
        for b in img_bytes:
            yield b
    elif bits_per_pixel == 4:
        for b in img_bytes:
            yield b >> 4
            yield b & 15
    elif bits_per_pixel == 2:
        for b in img_bytes:
            yield b >> 6
            yield (b & 0b00110000) >> 4
            yield (b & 0b00001100) >> 2
            yield (b & 0b00000011)
    else:
        raise ValueError("Unexpoected bits per pixel value: %d" % bits_per_pixel)


def print_header(message):
    print("== %s " % message + "=" * (60 - len(message)))


# this holds the sub-image cut out of the image
class SubImage:
    """
        img: the image
        x,y: upper left corner where the image was cut out
        part = part index (used for sprites that are larher than max sprite size)
        part_x, part_y = coords of the part, relative to x,y
        palette = palette found for this sub image
        transparent_color = the color meant to be transparent
    """

    def __init__(self, img, x, y, index, part_x, part_y, part_index, palette, transparent_color):
        self.img = img
        self.x = x
        self.y = y
        self.index = index
        self.part_x = part_x
        self.part_y = part_y
        self.part_index = part_index
        self.palette = palette
        self.transparent_color = transparent_color


def get_sub_images(img, upper_left, lower_right, partitioning, transparent_color_getter, max_palette_size=15,
                   max_x_size=(1 << 64), max_y_size=(1 << 64)):
    l, t = upper_left
    r, b = lower_right
    width = r - l + 1
    height = b - t + 1
    x_parts, y_parts = partitioning

    if width % x_parts != 0 or height % y_parts != 0:
        raise ValueError("The range (%s-%s)can not be partioned (by %s) without remainder" %
                         (upper_left, lower_right, partitioning))

    cell_width = int(width // x_parts)
    cell_height = int(height // y_parts)

    index = 0
    for y in range(t, b, cell_height):
        for x in range(l, r, cell_width):
            cropped = img.crop((x, y, x + cell_width, y + cell_height))
            tc = transparent_color_getter(cropped)

            # always chunk it up - it will only do one iteration anyway if the size fits
            part = 0
            for sy in range(0, cell_height, max_y_size):
                sh = min(cell_height - sy, max_y_size)
                for sx in range(0, cell_width, max_x_size):
                    sw = min(cell_width - sx, max_x_size)
                    sc = cropped.crop((sx, sy, sx + sw, sy + sh))
                    # sc.show() # for debugging

                    colors = get_unique_colors(sc)
                    if tc in colors:
                        colors.remove(tc)
                    if len(colors) > max_palette_size:
                        sc.show()
                        raise ValueError("Subimage with too many colors (%d) encountered" % len(colors))

                    if sh == cell_height and sw == cell_width:
                        part = None
                    yield SubImage(sc, x, y, index, sx, sy, part, colors, tc)
                    if part is not None:
                        part += 1
            index += 1


def get_img_bounding_box(img, transparent_color):
    """
        given an image and a transparent color
        find the bounding box of the non transparent pixels
        (so to be able to crop the image to the non transparent pixels
    """
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


def bytes_as_hex_text(data, bytes_per_line=24):
    p = 0
    output = ""

    while p < len(data):
        output += ".byte " + ",".join(['$' + ('0' + hex(b)[2:])[-2:] for b in data[p:p + bytes_per_line]]) + "\n"
        p += bytes_per_line

    return output


def flip_horizontal(tile, ts):
    return tuple(tile[y * ts + x] for y in range(ts) for x in range(ts - 1, -1, -1))


def flip_vertical(tile, ts):
    return tuple(tile[y * ts + x] for y in range(ts - 1, -1, -1) for x in range(ts))


def append_palette(pal, palette_bytes):
    palette_bytes.append(0)
    palette_bytes.append(0)  # first entry is always 0,0

    for r, g, b in pal:
        palette_bytes.append(((g // 17) << 4) + b // 17)
        palette_bytes.append(r // 17)

    # palettes can be incomplete, however a full palette will have more than 15 entries,
    # thus producing an empty range, so all is good
    missing_entries = 15 - len(pal)
    for i in range(missing_entries):
        palette_bytes.append(0)
        palette_bytes.append(0)


def load_image(filename):
    img = Image.open(filename)
    img = img.convert("RGB")
    # Convert the image to a Numpy array
    im_array = np.array(img)
    # Normalize the RGB values from [0, 255] to [0, 1]
    im_array = im_array / 255
    # Quantize the colors using Numpy
    quantized_array = (np.round(im_array / (17 / 255)) * (17 / 255)) * 255
    # Convert back to [0, 255]
    quantized_array = quantized_array.astype(np.uint8)
    img = Image.fromarray(quantized_array)

    return img


def load_image_plus_pal(filename):
    img = Image.open(filename)
    palette = img.palette

    # Normalize the RGB values from [0, 255] to [0, 1]
    palette = np.array(palette) / 255

    # Quantize the palette using Numpy
    quantized_palette = (np.round(palette / (17 / 255)) * (17 / 255)) * 255

    # Convert back to [0, 255]
    quantized_palette = quantized_palette.astype(np.uint8)

    # Update the palette in the image
    img.putpalette(quantized_palette)

    img = img.convert("RGB")
    return img, palette


def create_screen_buffer_entry(tile_index, palette_index, h_flip, v_flip):
    return tile_index & 255, (palette_index << 4) + (v_flip << 3) + (h_flip << 2) + (tile_index >> 8)


def write_palette_debug_png(filename, palette):
    img = Image.new("P", (1,1))
    imgdata = [0]
    img.putdata(imgdata)
    palette_bytes = bytearray()
    palette_bytes.extend([0,0,0])
    for p in palette:
        palette_bytes.extend(p)
    img.putpalette(palette_bytes)
    img.save(filename)