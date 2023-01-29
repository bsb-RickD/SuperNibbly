from ImageUtils import write_data, append_palette, print_header

MAX_SUB_PALETTE_SIZE = 15
MAX_FULL_PALETTE_SIZE = 256


def no_transparent_color():
    return lambda img: None


def fixed_transparent_color(color):
    return lambda img: color


def transparent_pixel(pos=(0, 0)):
    return lambda img: img.getpixel(pos)


def get_min_num_of_palettes(*args):
    print_header("Palette optimization")
    initial_palette_set = set()
    large_palette = set()
    large_palettes_count = 0
    for palette_generator in args:
        for p in palette_generator:
            if len(p) <= MAX_SUB_PALETTE_SIZE:
                initial_palette_set.add(tuple(p))
            else:
                large_palettes_count += 1
                large_palette = large_palette.union(set(tuple(p)))

    palettes = [set(p) for p in initial_palette_set]
    print("Starting with %d palettes and %d oversize palettes" % (len(palettes), large_palettes_count))

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
             if ai != bi and len(a.union(b)) <= MAX_SUB_PALETTE_SIZE], key=lambda x: x[0], reverse=True)
        if len(overlap):
            o, i, j = overlap[0]
            a = palettes[i]
            b = palettes[j]
            palettes.remove(a)
            palettes.remove(b)
            palettes.append(a.union(b))
        else:
            done = True

    # get the total of all colors in all palettes
    merged = set()
    for p in palettes:
        merged = merged.union(p)

    remaining_colors = large_palette.difference(merged)
    unique_color_count = len(merged) + len(remaining_colors)
    print("A total of %d unique colors found" % unique_color_count)

    for p in palettes:
        if len(p) <= MAX_SUB_PALETTE_SIZE:
            for i in range(min(MAX_SUB_PALETTE_SIZE - len(p), len(remaining_colors))):
                p.add(remaining_colors.pop())
        if len(remaining_colors) == 0:
            break

    while len(remaining_colors) > 0:
        new_pal = set()
        for i in range(min(MAX_SUB_PALETTE_SIZE, len(remaining_colors))):
            new_pal.add(remaining_colors.pop())
        palettes.append(new_pal)

    print("Reduced to %d palettes\n" % len(palettes))
    palette_color_count = len(palettes) * (MAX_SUB_PALETTE_SIZE + 1)
    print("Using %d colors to represent %d unique colors.. thats a ratio of %f" %
          (palette_color_count, unique_color_count, palette_color_count / unique_color_count))

    return palettes


class PaletteOptimizer:
    def __init__(self, *palette_providers):
        pals = (p.palettes() for p in palette_providers)
        self.palettes = get_min_num_of_palettes(*pals)

        if len(self.palettes[0]) > MAX_SUB_PALETTE_SIZE:
            raise ValueError(
                "Palette size expected to be max %d - but rececved %d" % (MAX_SUB_PALETTE_SIZE, len(self.palettes[0])))

        self.full_palette = list(self.palettes[0])
        for p in self.palettes[1:]:

            # pad to a multiple of 16 before adding a new palette
            remainder = len(self.full_palette) % (MAX_SUB_PALETTE_SIZE + 1)
            if remainder > 0:
                self.full_palette.extend([(0, 0, 0)] * ((MAX_SUB_PALETTE_SIZE + 1)-remainder))

            if len(p) == MAX_SUB_PALETTE_SIZE:
                self.full_palette.append((0, 0, 0))
            self.full_palette.extend(list(p))

        assert len(self.full_palette) <= MAX_FULL_PALETTE_SIZE

    def get_index(self, palette):
        if len(palette) <= MAX_SUB_PALETTE_SIZE:
            for index, pal in enumerate(self.palettes):
                if pal.issuperset(palette):
                    return index, pal

            raise ValueError("Sprite palette not found in optimized palettes!")
        else:
            if set(self.full_palette).issuperset(palette):
                return 0, self.full_palette
            raise ValueError("Sprite palette not found in full palette!")

    def save(self, filename, write_asm=False):
        palette_bytes = bytearray()
        for pal in self.palettes:
            append_palette(pal, palette_bytes)

        write_data(palette_bytes, filename, write_asm=write_asm)
        return palette_bytes
