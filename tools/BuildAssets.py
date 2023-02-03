from ImageTiler import ImageTiler
from ImageUtils import print_header, load_image, load_image_plus_pal
from PaletteOptimizer import no_transparent_color, PaletteOptimizer, fixed_transparent_color
from Sprites import SpriteGroup, MultiSprite, Sprite, SPRITE_LAYER_BACKGROUND


def super_nibbly_title():
    print_header("Super Nibbly Title")
    title = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\TITEL_BG_x16.png")
    titanm = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm.png")
    titanm_1 = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\titanm-1_x16.png")
    woodly2 = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\woodly2.png")

    # define the sprites
    sg1 = SpriteGroup([
        MultiSprite(titanm, (117, 18), (132, 101), (1, 6), name="smoke"),
        MultiSprite(titanm, (80, 19), (111, 188), (1, 17), name="fish"),
        MultiSprite(titanm, (1, 19), (32, 210), (1, 16), name="plane"),
        Sprite(woodly2, (1, 1), (51, 84), name="n"),
        Sprite(woodly2, (58, 1), (87, 72), name="i"),
        Sprite(woodly2, (91, 1), (145, 75), name="b1"),
        Sprite(woodly2, (150, 1), (204, 70), name="b2"),
        Sprite(woodly2, (209, 1), (260, 78), name="l"),
        Sprite(woodly2, (264, 1), (315, 82), name="y")
        ])
    sg2 = SpriteGroup([
        Sprite(titanm_1, (10, 452), (57, 500), name="head"),
        MultiSprite(titanm_1, (474, 455), (581, 496), (3, 1), name="necks"),
        MultiSprite(titanm_1, (273, 1), (290, 171), (1, 19), name="eyes_blinking"),
        MultiSprite(titanm_1, (10, 375), (297, 402), (6, 1), name="hats"),
        MultiSprite(titanm_1, (10, 403), (297, 423), (6, 1), name="mouths"),
        MultiSprite(titanm_1, (9, 9), (88, 344), (1, 7), name="bubbles", max_part_y_size=32),
        Sprite(titanm_1, (106, 218), (128, 241), name="thinking"),
        Sprite(titanm_1, (177, 179), (188, 202), name="jf_son"),
        Sprite(titanm_1, (138, 50), (189, 125), name="45degree"),
        MultiSprite(titanm_1, (206, 69), (221, 136), (1, 4), name="45deg_blinking"),
        Sprite(titanm_1, (400, 81), (431, 112), name="mum"),
        Sprite(titanm_1, (312, 7), (385, 80), name="bigmum"),
        Sprite(titanm_1, (311, 98), (350, 115), name="head_crash"),
        Sprite(titanm_1, (316, 209), (395, 240), name="jf_fat"),
        Sprite(titanm_1, (410, 322), (460, 353), name="zack"),
        MultiSprite(titanm_1, (421, 369), (452, 395), (1,3), name="toff_crash_slup"),
        Sprite(titanm_1, (471, 334), (497, 365), name="debris_hat"),
        Sprite(titanm_1, (501, 335), (521, 353), name="debris_tail"),
        Sprite(titanm_1, (526, 334), (561, 368), name="debris_prop"),
        Sprite(titanm_1, (574, 340), (621, 359), name="debris_wing", max_part_x_size=32),
        MultiSprite(titanm_1, (589, 280), (636, 326), (3, 1), name="propeller"),
        Sprite(titanm_1, (317, 253), (392, 319), name="t1000", max_part_x_size=32, max_part_y_size=32),
        Sprite(titanm_1, (480, 250), (582, 327), name="bigplane", max_part_x_size=32),
    ])

    # background image
    it = ImageTiler(title, no_transparent_color())

    # optimize palette
    po = PaletteOptimizer(it, sg1, sg2)

    # use optimized palette for tiles and sprites
    it.calc_tiles(po)
    sg1.calc_sprite_bitmaps(po, it.get_used_memory())
    sg2.calc_sprite_bitmaps(po, it.get_used_memory())

    # write the sprites as debug images
    sg1.save_as_png(po)

    # save some space on sprites
    it.hide_sprites_in_screen_buffer(sg1)

    # write everything to disk
    sg1.save("intro_sprites")
    sg2.save("intro_sprites_2")
    po.save("intro_palette")
    it.save("intro")


def super_nibbly_travel():
    print_header("Super Nibbly Travel Screen")
    travel, pal = load_image_plus_pal(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\LMAPP_x16.png")
    anim = load_image(r"C:\Users\epojar\Dropbox\OldDiskBackup\Nibbly\All_PNG_Files\minanm.png")

    # background image
    it = ImageTiler(travel, fixed_transparent_color((pal.palette[0], pal.palette[1], pal.palette[2])))

    sg_main = SpriteGroup([
        MultiSprite(anim, (246, 32), (293, 231), (1, 10), name="speech_big"),
        MultiSprite(anim, (214, 32), (237, 151), (1, 6), name="speech_medium"),
        MultiSprite(anim, (214, 14), (261, 30), (2, 1), name="speech_small"),
    ])

    y_start = 0
    landscape_sprite_groups = []

    common_params = {"optimize_size": False, "layer": SPRITE_LAYER_BACKGROUND}
    for i in range(4):
        landscape_sprite_groups.append(SpriteGroup([
            MultiSprite(anim, (0, 80 + y_start), (95, 103 + y_start), (3, 1), name="mountain_bg", **common_params),
            MultiSprite(anim, (0, 104 + y_start), (95, 111 + y_start), (3, 1), name="mountain_fg", **common_params),
            MultiSprite(anim, (104, 88 + y_start), (135, 111 + y_start), (2, 1), name="trees", **common_params),
            MultiSprite(anim, (136, 80 + y_start), (183, 111 + y_start), (2, 1), name="houses", **common_params)
        ]))
        y_start += 32

    # optimize palette
    po = PaletteOptimizer(it, sg_main, *landscape_sprite_groups)

    # use optimized palette for tiles and sprites
    it.calc_tiles(po)
    sg_main.calc_sprite_bitmaps(po, it.get_used_memory())

    # save some space on sprites
    it.hide_sprites_in_screen_buffer(sg_main)

    # calc memory of screen + common spritets
    total_used_memory = it.get_used_memory() + sg_main.get_used_memory()

    # save anim sprites
    landscapes = ["green", "ice", "volcano", "desert"]
    for i in range(4):
        landscape_sprite_groups[i].calc_sprite_bitmaps(po, total_used_memory)
        landscape_sprite_groups[i].save("travel_%s_sprites" % landscapes[i])
        landscape_sprite_groups[i].save_just_pal_index("travel_%s_pal_indexes" % landscapes[i])

    # write everything to disk
    sg_main.save("travel_common_sprites")
    po.save("travel_palette")
    it.save("travel")


if __name__ == "__main__":
    super_nibbly_title()
    #super_nibbly_travel()
