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


def make_copper_list(colors, lines):
    if len(colors) != len(lines):
        raise ValueError("Need to specifiy the same number of colors and lines! colors: %d lines: %d" %
                         (len(colors), len(lines)))

    data = list(zip(lines, colors))

    output = []

    for i in range(1, len(colors)):
        l1, c1 = data[i - 1]
        l2, c2 = data[i]
        for l, (r, g, b) in interpolate(l1, c1, l2, c2):
            l = int(l)
            rc = int((r + 8.5) / 17)
            gc = int((g + 8.5) / 17)
            bc = int((b + 8.5) / 17)
            if len(output) == 0:
                output.append((l, (rc, gc, bc)))
            else:
                pl, (prc, pgc, pbc) = output[-1]
                if pl != l and (rc != prc or pgc != gc or bc != pbc):
                    output.append((l, (rc, gc, bc)))

    return output


if __name__ == "__main__":
    water = make_copper_list(
        ((171, 160, 248), (208, 200, 253), (208, 200, 253), (116, 104, 243), (19, 52, 195), (116, 138, 243)),
        (6, 14, 16, 37, 38, 61))

    green = make_copper_list(
        ((171, 160, 248), (208, 200, 253), (208, 200, 253), (116, 104, 243),
         (52, 124, 52), (52, 179, 52),
         (131, 131, 131), (131, 131, 131), (163, 163, 163), (163, 163, 163), (131, 131, 131), (131, 131, 131),
         (64, 192, 60), (100, 227, 70)),
         (6, 14, 16, 37, 38, 45, 46, 46, 47, 52, 53, 53, 54, 61))

    print(green)
