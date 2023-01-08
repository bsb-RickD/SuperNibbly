from ordered_set import OrderedSet


def get_sub_images(img, upper_left, lower_right, partitioning):
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

    for y in range(t, b, cell_height):
        for x in range(l, r, cell_width):
            cropped = img.crop((x, y, x + cell_width, y + cell_height))
            yield cropped, x, y


def no_transparent_color():
    return lambda img: None


def transparent_color(color):
    return lambda img: color


def transparent_pixel(pos=(0, 0)):
    return lambda img: img.getpixel(pos)


def get_unique_colors(img):
    return OrderedSet(img.getdata())


def get_palettes_from_images(image_generator, transparent_color_getter):
    for img, _, _ in image_generator:
        colors = get_unique_colors(img)
        tc = transparent_color_getter(img)
        if tc in colors:
            colors.remove(tc)
        yield tuple(colors)


def get_min_num_of_palettes(*args):
    initial_palette_set = set()
    for palette_generator in args:
        for p in palette_generator:
            initial_palette_set.add(p)

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

    print("Reduced to %d palettes" % len(palettes))

    return palettes
