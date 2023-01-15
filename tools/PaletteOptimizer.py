from ImageUtils import write_data, append_palette, print_header


def no_transparent_color():
    return lambda img: None


def transparent_color(color):
    return lambda img: color


def transparent_pixel(pos=(0, 0)):
    return lambda img: img.getpixel(pos)


"""
def get_palettes_from_images(image_generator, transparent_color_getter):
    for img, _, _ in image_generator:
        colors = get_unique_colors(img)
        tc = transparent_color_getter(img)
        if tc in colors:
            colors.remove(tc)
        yield tuple(colors)
"""


def get_min_num_of_palettes(*args):
    print_header("Palette optimization")
    initial_palette_set = set()
    for palette_generator in args:
        for p in palette_generator:
            initial_palette_set.add(tuple(p))

    palettes = [set(p) for p in initial_palette_set]
    print("Starting with %d palettes" % len(palettes))

    p2 = []
    for pi, p in enumerate(palettes):
        for q in palettes[pi + 1:]:
            if p.issubset(q):
                break
        else:
            p2.append(p)

    palettes = p2
    print("removed subsets, before merge: %d palettes" % len(palettes))

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

    print("Reduced to %d palettes\n" % len(palettes))

    return palettes


class PaletteOptimizer:
    def __init__(self, *palette_providers):
        pals = (p.palettes() for p in palette_providers)
        self.palettes = get_min_num_of_palettes(*pals)

    def get_index(self, palette):
        for index, pal in enumerate(self.palettes):
            if pal.issuperset(palette):
                return index, pal

        raise ValueError("Sprite palette not found in optimized palettes!")

    def save(self, filename, write_asm=False):
        palette_bytes = bytearray()
        for pal in self.palettes:
            append_palette(pal, palette_bytes)

        write_data(palette_bytes, filename, write_asm=write_asm)
        return palette_bytes
