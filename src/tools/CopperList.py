from ImageUtils import load_image


def lerp(start, end, steps):
    if steps == 1:
        yield end
        return
    step = (end - start) / (steps - 1)
    for s in range(steps):
        if s == (steps - 1):
            yield end
        else:
            yield start + step * s


def interpolate(line1, color1, line2, color2):
    ldif = (line2 - line1) + 1
    rg = lerp(color1[0], color2[0], ldif)
    gg = lerp(color1[1], color2[1], ldif)
    bg = lerp(color1[2], color2[2], ldif)

    for l in lerp(line1, line2, ldif):
        yield l, (next(rg), next(gg), next(bg))


def fill_copper_list(l, r, g, b, output):
    l = int(l)
    rc = int((r+8.5) / 17)
    gc = int((g+8.5) / 17)
    bc = int((b+8.5) / 17)
    if len(output) == 0:
        output.append((l, (rc, gc, bc)))
    else:
        pl, (prc, pgc, pbc) = output[-1]
        if pl != l and (rc != prc or pgc != gc or bc != pbc):
            output.append((l, (rc, gc, bc)))


def make_copper_list(colors, lines, name):
    if len(colors) != len(lines):
        raise ValueError("Need to specifiy the same number of colors and lines! colors: %d lines: %d" %
                         (len(colors), len(lines)))

    data = list(zip(lines, colors))
    output = []

    for i in range(1, len(colors)):
        l1, c1 = data[i - 1]
        l2, c2 = data[i]
        for l, (r, g, b) in interpolate(l1, c1, l2, c2):
            fill_copper_list(l, r, g, b, output)

    str = serialize_copper_list(name, output)

    return str


def serialize_copper_list(name, output):
    str = "%s:\n" % name
    for l, (r, g, b) in output:
        str += ".word %03d, $%s\t; line, color\n" % (l * 2, hex((r << 8) + (g << 4) + b)[2:])
    str += ".word $FFFF\t\t; marking the end"
    return str


def make_copper_list_from_image(img, x, y_start, y_end, name, first_line=0):
    output = []
    offset = y_start - first_line
    for y in range(y_start, y_end + 1):
        l = y - offset
        r, g, b = img.getpixel((x, y))
        fill_copper_list(l, r, g, b, output)

    return serialize_copper_list(name, output)


if __name__ == "__main__":
    water = make_copper_list(
        ((171, 160, 248), (208, 200, 253), (208, 200, 253), (116, 104, 243), (19, 52, 195), (116, 138, 243)),
        (6, 14, 16, 37, 38, 61), "water")

    green = make_copper_list(
        ((171, 160, 248), (208, 200, 253), (208, 200, 253), (116, 104, 243),
         (52, 124, 52), (52, 179, 52),
         (131, 131, 131), (131, 131, 131), (163, 163, 163), (163, 163, 163), (131, 131, 131), (131, 131, 131),
         (64, 192, 60), (100, 227, 70)),
        (6, 14, 16, 37, 38, 45, 46, 46, 47, 52, 53, 53, 54, 61),
        "green_copper"
    )

    # print(green)
    img = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\examples.png")
    print(make_copper_list_from_image(img, 206, 83, 183, "volcano_copper_list", 6))
    print(make_copper_list_from_image(img, 212, 83, 183, "green_copper_list", 6))
    print(make_copper_list_from_image(img, 219, 83, 183, "ice_copper_list", 6))
    print(make_copper_list_from_image(img, 223, 83, 183, "desert_copper_list", 6))
    print(make_copper_list_from_image(img, 227, 83, 183, "water_copper_list", 6))
