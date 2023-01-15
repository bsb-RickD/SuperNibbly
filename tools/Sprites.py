from PIL import Image
from typing import List, Any
from PaletteOptimizer import transparent_pixel, get_palettes_from_images
from ImageUtils import map_colors_to_index, image_bytes, get_sub_images, get_img_bounding_box, write_data, SubImage
from itertools import chain

SPRITE_SIZES = (8, 16, 32, 64)
MAX_SPRITE_SIZE = SPRITE_SIZES[-1]


def get_next_bigger_sprite_size(size):
    for c in SPRITE_SIZES:
        if size <= c:
            return c
    return size


def pad_sprite_to_next_size(img, transparent_color):
    w, h = img.size
    ws = get_next_bigger_sprite_size(w)
    hs = get_next_bigger_sprite_size(h)
    if ws != w or hs != h:
        new_img = Image.new(img.mode, (ws, hs), transparent_color)
        new_img.paste(img, (0, 0))
        return new_img
    return img


# this class gets constructed with the sprite coordinates, and it turns this into a number of Subimages
class MultiSprite:
    def __init__(self, img, upper_left, lower_right, frames, name,
                 transparency=transparent_pixel, optimize_size=True):
        self.img = img
        self.upper_left = upper_left
        self.lower_right = lower_right
        self.images = frames
        self.name = name
        self.transparency = transparency
        self.optimize_size = optimize_size
        self.images = [i for i in get_sub_images(img, upper_left, lower_right, frames, transparency(), MAX_SPRITE_SIZE)]


# pseudo constructor for sprintes with a single frame
# noinspection PyPep8Naming
def Sprite(img, upper_left, lower_right, name, transparency=transparent_pixel, optimize_size=True):
    return MultiSprite(img, upper_left, lower_right, (1, 1), name, transparency, optimize_size)


# this is the class that holds the actual sprite bitmap information
# the actual bitmap, palette index, etc.
class SpriteBitmap:
    def __init__(self, sub_image: SubImage, name, transparent_color_getter, optimized_palettes,
                 optimize_size):
        self.width = 0
        self.height = 0  # size of sprite (8,16,32,64) x (8,16,32,64)
        self.x_offset = 0
        self.y_offset = 0  # offset of upper right corner
        self.data = None  # the actual sprite data
        self.palette_index = 0  # palette frame
        self.frame = 0  # animation frame of the sprite
        self.part = 0
        self.data_offset = 0  # where in the sprite data block is this sprite located, divided by 32
        self.name = ""
        self.basename = name

        spritepal = sub_image.palette
        for index, pal in enumerate(optimized_palettes):
            if pal.issuperset(spritepal):
                palindex = index
                break
        else:
            raise ValueError("Sprite palette not found in optimized palettes!")

        transparent_color = transparent_color_getter(sub_image.img)
        colors = list(pal)
        colors.insert(0, transparent_color)

        if optimize_size:
            bbox = get_img_bounding_box(sub_image.img, transparent_color)
        else:
            bbox = (0, 0, *sub_image.img.size)
        if bbox is not None:
            padded_sprite_frame = pad_sprite_to_next_size(sub_image.img.crop(bbox), transparent_color)
            # padded_sprite_frame.show() # for debugging
            self.width, self.height = padded_sprite_frame.size
            self.xoffset = bbox[0] + sub_image.part_x
            self.yoffset = bbox[1] + sub_image.part_y
            self.palette_index = palindex
            self.data = image_bytes(map_colors_to_index(padded_sprite_frame, colors, 0), 4)
            self.frame = sub_image.index
            self.part = sub_image.part_index
            self.name = "%s_%d" % (name, self.frame)
            if self.part is not None:
                self.name += "_%d" % self.part


# a spritegroup is used to group Sprites together, to write the sprite data to a file
# this class also takes care of converting the Sprites and the subimages into SpriteBitmaps
class SpriteGroup:
    def __init__(self, filename: str, sprites: List[MultiSprite]):
        self.filename = filename
        self.sprites = sprites
        self.sprite_bitmaps = []

    def palettes(self) -> chain:
        chained: chain[Any] = chain()
        for s in self.sprites:
            chained = chain(chained, (f.palette for f in s.images))
        return chained

    def calc_sprite_bitmaps(self, optimized_palettes, offset):
        self.sprite_bitmaps = []
        for s in self.sprites:
            for img in s.images:
                sb = SpriteBitmap(img, s.name, s.transparency(), optimized_palettes, s.optimize_size)
                self.sprite_bitmaps.append(sb)
        self.update_sprite_offsets(offset)

    def update_sprite_offsets(self, offset):
        co = offset
        for sb in self.sprite_bitmaps:
            size = len(sb.data)
            if size != 0:
                sb.data_offset = int(co//32)  # if size 0, it's a hidden sprite and that already knows it's data offset
            co += len(sb.data)

    def save(self):
        sprite_data = bytearray()
        for sb in self.sprite_bitmaps:
            sprite_data += bytearray(sb.data)

        write_data(sprite_data, self.filename)

        with open(self.filename + ".inc", "wt") as fp:
            for sb in self.sprite_bitmaps:
                # watch out - for hidden sprites len(sprite.data) = 0
                sprite_size = len(sb.data)
                sprite_colors = 256 if sb.width * sb.height == sprite_size else 16
                fp.write("; Sprite %s, frame %d%s (%dx%d - %d colors)\n" %
                         (sb.basename, sb.frame, ("" if sb.part is None else ", part %d " % sb.part),
                          sb.width, sb.height, sprite_colors))
                fp.write("sprite_%s:\n" % sb.name)
                fp.write(".byte %d, %d\t; x- and y-offset\n" % (sb.xoffset, sb.yoffset))

                address = sb.data_offset  # hidden sprites know their address

                fp.write(
                    ".word %d+VERA_sprite_colors_%d\t; address/32 (+ color indicator) \n" % (address, sprite_colors))
                fp.write(".word 0, 0\t; x,y pos\n")
                fp.write(".byte %d\t; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip\n" % (3 << 2))
                fp.write(".byte VERA_sprite_height_%d+VERA_sprite_width_%d+%d\t;h, w, palette index\n\n" %
                         (sb.height, sb.width, sb.palette_index))
