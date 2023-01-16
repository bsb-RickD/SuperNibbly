from ImageTiler import ImageTiler
from ImageUtils import print_header, load_image
from PaletteOptimizer import no_transparent_color, PaletteOptimizer, transparent_color
from Sprites import SpriteGroup, MultiSprite, Sprite


def super_nibbly_title():
    print_header("Super Nibbly Title")
    title = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\TITEL_BG_x16.png")
    titanm = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm.png")
    woodly2 = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\woodly2.png")

    # define the sprites
    sg = SpriteGroup([
        MultiSprite(titanm, (117, 18), (132, 101), (1, 6), name="smoke"),
        MultiSprite(titanm, (80, 19), (111, 188), (1, 17), name="fish"),
        MultiSprite(titanm, (1, 19), (32, 210), (1, 16), name="plane"),
        Sprite(woodly2, (1, 1), (51, 84), name="n"),
        Sprite(woodly2, (58, 1), (87, 72), name="i"),
        Sprite(woodly2, (91, 1), (145, 75), name="b1"),
        Sprite(woodly2, (150, 1), (204, 70), name="b2"),
        Sprite(woodly2, (209, 1), (260, 78), name="l"),
        Sprite(woodly2, (264, 1), (315, 82), name="y"),
    ])

    # background image
    it = ImageTiler(title, no_transparent_color())

    # optimize palette
    po = PaletteOptimizer(it, sg)

    # use optimized palette for tiles and sprites
    it.calc_tiles(po)
    sg.calc_sprite_bitmaps(po, it.get_used_memory())

    # save some space on sprites
    it.hide_sprites_in_screen_buffer(sg.sprite_bitmaps)

    # write everything to disk
    sg.save("intro_sprites")
    po.save("intro_palette")
    it.save("intro")


def super_nibbly_travel():
    print_header("Super Nibbly Travel Screen")
    travel = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\LMAPP_x16.png")
    anim = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\minanm.png")

    # background image
    it = ImageTiler(travel, transparent_color((255, 0, 0)))

    sg_main = SpriteGroup([
        MultiSprite(anim, (246, 32), (293, 231), (1, 10), name="speech_big"),
        MultiSprite(anim, (214, 32), (237, 151), (1, 6), name="speech_medium"),
        MultiSprite(anim, (214, 14), (261, 30), (2, 1), name="speech_small"),
    ])

    y_start = 0
    landscape_sprite_groups = []

    for i in range(4):
        landscape_sprite_groups.append(SpriteGroup([
            MultiSprite(anim, (0, 80 + y_start), (95, 103 + y_start), (3, 1), name="mountain_bg", optimize_size=False),
            MultiSprite(anim, (0, 104 + y_start), (95, 111 + y_start), (3, 1), name="mountain_fg", optimize_size=False),
            MultiSprite(anim, (104, 88 + y_start), (135, 111 + y_start), (2, 1), name="trees", optimize_size=False),
            MultiSprite(anim, (136, 80 + y_start), (183, 111 + y_start), (2, 1), name="houses", optimize_size=False)
        ]))
        y_start += 32

    # optimize palette
    po = PaletteOptimizer(it, sg_main, *landscape_sprite_groups)

    # use optimized palette for tiles and sprites
    it.calc_tiles(po)
    sg_main.calc_sprite_bitmaps(po, it.get_used_memory())

    # save some space on sprites
    it.hide_sprites_in_screen_buffer(sg_main.sprite_bitmaps)

    # calc memory of screen + common spritets
    total_used_memory = it.get_used_memory() + sg_main.get_used_memory()

    # save anim sprites
    landscapes = ["green", "ice", "vulcano", "desert"]
    for i in range(4):
        landscape_sprite_groups[i].calc_sprite_bitmaps(po, total_used_memory)
        landscape_sprite_groups[i].save("travel_%s_sprites" % landscapes[i])

    # write everything to disk
    sg_main.save("travel_common_sprites")
    po.save("travel_palette")
    it.save("travel")

if __name__ == "__main__":
    super_nibbly_title()
    super_nibbly_travel()
