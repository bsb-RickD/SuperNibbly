from PIL import Image
from ordered_set import OrderedSet


def get_mask(img):
    mask = Image.new(mode="L", size=img.size)
    w, h = img.size
    for y in range(h):
        for x in range(w):
            p = img.getpixel((x, y))
            if p == 0:
                mask.putpixel((x, y), 0)
            else:
                mask.putpixel((x, y), 255)
    return mask


def grab_tiles(img):
    positions = ((5,5),(1,1),(2,1),(3,1),(1,2),(1,3),(3,3))

    tiles = Image.new(mode = "P", size = (16, 16*7), color = 0)
    tiles.putpalette(img.getpalette())

    for i, (x,y) in enumerate(positions):
        tiles.paste(img.crop((x*16, y*16, x*16+16, y*16+16)), (0,i*16))

    return tiles



def build_image(wall, pill=None):
    lab = [ [1,0,1,1,0,0],
        [0,0,0,0,0,0],
        [1,0,1,1,0,0],
        [1,0,1,0,0,0],
        [0,0,0,0,0,0],
        [0,0,0,0,0,0]
       ]

    wm = get_mask(wall)

    if pill is not None:
        pm = get_mask(pill)

    tiled = Image.new(mode = "P", size = (16*6, 16*6), color = 0)
    tiled.putpalette(wall.getpalette())

    for y in range(6):
        for x in range(6):
            entry = lab[y][x]

            if entry == 1:
                tiled.paste(wall, (16*x,16*y), mask = wm)
            elif (entry == 0) and (pill is not None):
                tiled.paste(pill, (16 * x, 16 * y), mask=pm)

    return tiled


def main():
    img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\level1.png")

    pills  = (None, img.crop((81, 77, 97, 93)), img.crop((81, 60, 97, 76)), img.crop((81, 43, 97, 59)),\
             img.crop((81, 26, 97, 42)), img.crop((81, 9, 97, 25)))

    for n in range (1,8):
        img = Image.open(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\level%d.png"%n)
        wall = img.crop((21, 5, 42,26))

        tiled = Image.new(mode="P", size=(16, 16 * 42+16), color=0)
        tiled.putpalette(wall.getpalette())

        for i, p in enumerate(pills):
            tiled.paste(grab_tiles(build_image(wall,p)),(0,7*16*i))
        tiled.paste(wall,(0,16*42))

        tiled.show()


if __name__ == "__main__":
    main()