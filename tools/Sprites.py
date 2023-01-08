from typing import List
from PaletteOptimizer import get_sub_images, transparent_pixel, get_palettes_from_images
from itertools import chain


class SubImage:
    def __init__(self, img, x, y, palette):
        self.img = img
        self.x = x
        self.y = y
        self.palette = palette


class Sprites:
    def __init__(self, img, upper_left, lower_right, frames, name,
                 transparency=transparent_pixel, optimize_size=False):
        self.img = img
        self.upper_left = upper_left
        self.lower_right = lower_right
        self.frames = frames
        self.name = name
        self.transparency = transparency
        self.optimize_size = optimize_size
        images_xy = [i for i in get_sub_images(img, upper_left, lower_right, frames)]
        palettes = [p for p in get_palettes_from_images((ixy for ixy in images_xy), transparency())]
        self.frames = [SubImage(i, x, y, p) for (i, x, y), p in zip(images_xy, palettes)]


class SpriteGroup:
    def __init__(self, name: str, sprites: List[Sprites]):
        self.name = name
        self.sprites = sprites

    def palettes(self) -> chain:
        chained = chain()
        for s in self.sprites:
            chained = chain(chained, (f.palette for f in s.frames))

        return chained
