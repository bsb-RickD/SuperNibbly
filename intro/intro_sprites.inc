; Sprite smoke, frame 0 (8x16 - 16 colors)
sprite_smoke_0:
.byte 4, 3	; x- and y-offset
.word 124+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite smoke, frame 1 (8x16 - 16 colors)
sprite_smoke_1:
.byte 3, 3	; x- and y-offset
.word 126+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite smoke, frame 2 (8x16 - 16 colors)
sprite_smoke_2:
.byte 3, 2	; x- and y-offset
.word 646+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite smoke, frame 3 (8x16 - 16 colors)
sprite_smoke_3:
.byte 3, 2	; x- and y-offset
.word 648+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite smoke, frame 4 (8x16 - 16 colors)
sprite_smoke_4:
.byte 4, 1	; x- and y-offset
.word 650+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite smoke, frame 5 (8x16 - 16 colors)
sprite_smoke_5:
.byte 3, 1	; x- and y-offset
.word 652+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+2	;h, w, palette index

; Sprite fish, frame 0 (8x8 - 16 colors)
sprite_fish_0:
.byte 8, 6	; x- and y-offset
.word 3+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 1 (16x8 - 16 colors)
sprite_fish_1:
.byte 5, 4	; x- and y-offset
.word 654+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 2 (16x8 - 16 colors)
sprite_fish_2:
.byte 4, 2	; x- and y-offset
.word 656+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 3 (16x8 - 16 colors)
sprite_fish_3:
.byte 3, 1	; x- and y-offset
.word 658+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 4 (16x16 - 16 colors)
sprite_fish_4:
.byte 4, 0	; x- and y-offset
.word 660+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 5 (8x8 - 16 colors)
sprite_fish_5:
.byte 8, 0	; x- and y-offset
.word 7+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 6 (8x8 - 16 colors)
sprite_fish_6:
.byte 9, 0	; x- and y-offset
.word 11+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 7 (8x8 - 16 colors)
sprite_fish_7:
.byte 10, 0	; x- and y-offset
.word 15+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 8 (8x8 - 16 colors)
sprite_fish_8:
.byte 12, 1	; x- and y-offset
.word 19+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 9 (8x8 - 16 colors)
sprite_fish_9:
.byte 11, 3	; x- and y-offset
.word 23+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+10	;h, w, palette index

; Sprite fish, frame 10 (16x8 - 16 colors)
sprite_fish_10:
.byte 9, 5	; x- and y-offset
.word 664+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 11 (16x8 - 16 colors)
sprite_fish_11:
.byte 7, 6	; x- and y-offset
.word 666+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+10	;h, w, palette index

; Sprite fish, frame 12 (32x8 - 16 colors)
sprite_fish_12:
.byte 5, 6	; x- and y-offset
.word 668+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+8	;h, w, palette index

; Sprite fish, frame 13 (32x8 - 16 colors)
sprite_fish_13:
.byte 4, 5	; x- and y-offset
.word 672+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+8	;h, w, palette index

; Sprite fish, frame 14 (32x8 - 16 colors)
sprite_fish_14:
.byte 4, 5	; x- and y-offset
.word 676+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+8	;h, w, palette index

; Sprite fish, frame 15 (32x8 - 16 colors)
sprite_fish_15:
.byte 3, 5	; x- and y-offset
.word 680+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+8	;h, w, palette index

; Sprite fish, frame 16 (32x8 - 16 colors)
sprite_fish_16:
.byte 2, 5	; x- and y-offset
.word 684+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+8	;h, w, palette index

; Sprite plane, frame 0 (16x8 - 16 colors)
sprite_plane_0:
.byte 2, 4	; x- and y-offset
.word 688+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 1 (16x8 - 16 colors)
sprite_plane_1:
.byte 2, 3	; x- and y-offset
.word 690+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 2 (16x16 - 16 colors)
sprite_plane_2:
.byte 3, 2	; x- and y-offset
.word 692+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 3 (8x16 - 16 colors)
sprite_plane_3:
.byte 5, 1	; x- and y-offset
.word 696+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 4 (8x16 - 16 colors)
sprite_plane_4:
.byte 6, 0	; x- and y-offset
.word 698+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 5 (8x16 - 16 colors)
sprite_plane_5:
.byte 6, 0	; x- and y-offset
.word 700+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 6 (16x16 - 16 colors)
sprite_plane_6:
.byte 4, 1	; x- and y-offset
.word 702+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 7 (16x8 - 16 colors)
sprite_plane_7:
.byte 3, 3	; x- and y-offset
.word 706+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 8 (16x8 - 16 colors)
sprite_plane_8:
.byte 2, 3	; x- and y-offset
.word 708+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 9 (16x8 - 16 colors)
sprite_plane_9:
.byte 3, 3	; x- and y-offset
.word 710+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 10 (16x16 - 16 colors)
sprite_plane_10:
.byte 4, 3	; x- and y-offset
.word 712+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 11 (8x16 - 16 colors)
sprite_plane_11:
.byte 5, 1	; x- and y-offset
.word 716+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 12 (8x16 - 16 colors)
sprite_plane_12:
.byte 6, 0	; x- and y-offset
.word 718+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 13 (8x16 - 16 colors)
sprite_plane_13:
.byte 5, 0	; x- and y-offset
.word 720+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+8	;h, w, palette index

; Sprite plane, frame 14 (16x16 - 16 colors)
sprite_plane_14:
.byte 4, 1	; x- and y-offset
.word 722+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+8	;h, w, palette index

; Sprite plane, frame 15 (16x8 - 16 colors)
sprite_plane_15:
.byte 3, 2	; x- and y-offset
.word 726+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+8	;h, w, palette index

; Sprite n, frame 0, part 0  (64x64 - 16 colors)
sprite_n_0_0:
.byte 0, 0	; x- and y-offset
.word 728+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite n, frame 0, part 1  (64x32 - 16 colors)
sprite_n_0_1:
.byte 0, 64	; x- and y-offset
.word 792+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite i, frame 0, part 0  (32x64 - 16 colors)
sprite_i_0_0:
.byte 0, 0	; x- and y-offset
.word 824+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+4	;h, w, palette index

; Sprite i, frame 0, part 1  (32x8 - 16 colors)
sprite_i_0_1:
.byte 0, 64	; x- and y-offset
.word 856+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite b1, frame 0, part 0  (64x64 - 16 colors)
sprite_b1_0_0:
.byte 0, 0	; x- and y-offset
.word 860+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b1, frame 0, part 1  (64x16 - 16 colors)
sprite_b1_0_1:
.byte 0, 64	; x- and y-offset
.word 924+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b2, frame 0, part 0  (64x64 - 16 colors)
sprite_b2_0_0:
.byte 0, 0	; x- and y-offset
.word 940+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b2, frame 0, part 1  (64x8 - 16 colors)
sprite_b2_0_1:
.byte 0, 64	; x- and y-offset
.word 1004+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_64+4	;h, w, palette index

; Sprite l, frame 0, part 0  (64x64 - 16 colors)
sprite_l_0_0:
.byte 0, 0	; x- and y-offset
.word 1012+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite l, frame 0, part 1  (64x16 - 16 colors)
sprite_l_0_1:
.byte 0, 64	; x- and y-offset
.word 1076+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite y, frame 0, part 0  (64x64 - 16 colors)
sprite_y_0_0:
.byte 0, 0	; x- and y-offset
.word 1092+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite y, frame 0, part 1  (64x32 - 16 colors)
sprite_y_0_1:
.byte 0, 64	; x- and y-offset
.word 1156+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite head, frame 0 (64x64 - 16 colors)
sprite_head_0:
.byte 6, 10	; x- and y-offset
.word 1188+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite necks, frame 0 (64x64 - 16 colors)
sprite_necks_0:
.byte 1, 5	; x- and y-offset
.word 1252+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite necks, frame 1 (64x64 - 16 colors)
sprite_necks_1:
.byte 0, 0	; x- and y-offset
.word 1316+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite necks, frame 2 (64x64 - 16 colors)
sprite_necks_2:
.byte 1, 0	; x- and y-offset
.word 1380+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite eyes, frame 0 (32x8 - 16 colors)
sprite_eyes_0:
.byte 0, 1	; x- and y-offset
.word 1444+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 1 (32x8 - 16 colors)
sprite_eyes_1:
.byte 0, 1	; x- and y-offset
.word 1448+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 2 (32x8 - 16 colors)
sprite_eyes_2:
.byte 0, 1	; x- and y-offset
.word 1452+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 3 (32x8 - 16 colors)
sprite_eyes_3:
.byte 0, 1	; x- and y-offset
.word 1456+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 4 (32x8 - 16 colors)
sprite_eyes_4:
.byte 0, 1	; x- and y-offset
.word 1460+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 5 (32x8 - 16 colors)
sprite_eyes_5:
.byte 0, 1	; x- and y-offset
.word 1464+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 6 (32x8 - 16 colors)
sprite_eyes_6:
.byte 0, 1	; x- and y-offset
.word 1468+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 7 (32x8 - 16 colors)
sprite_eyes_7:
.byte 0, 1	; x- and y-offset
.word 1472+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 8 (32x8 - 16 colors)
sprite_eyes_8:
.byte 0, 1	; x- and y-offset
.word 1476+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 9 (32x16 - 16 colors)
sprite_eyes_9:
.byte 0, 0	; x- and y-offset
.word 1480+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 10 (32x8 - 16 colors)
sprite_eyes_10:
.byte 0, 1	; x- and y-offset
.word 1488+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 11 (32x8 - 16 colors)
sprite_eyes_11:
.byte 0, 1	; x- and y-offset
.word 1492+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 12 (32x8 - 16 colors)
sprite_eyes_12:
.byte 0, 1	; x- and y-offset
.word 1496+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 13 (32x8 - 16 colors)
sprite_eyes_13:
.byte 0, 1	; x- and y-offset
.word 1500+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 14 (32x8 - 16 colors)
sprite_eyes_14:
.byte 0, 1	; x- and y-offset
.word 1504+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 15 (32x8 - 16 colors)
sprite_eyes_15:
.byte 0, 1	; x- and y-offset
.word 1508+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 16 (32x8 - 16 colors)
sprite_eyes_16:
.byte 0, 1	; x- and y-offset
.word 1512+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 17 (32x8 - 16 colors)
sprite_eyes_17:
.byte 0, 1	; x- and y-offset
.word 1516+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes, frame 18 (32x8 - 16 colors)
sprite_eyes_18:
.byte 0, 1	; x- and y-offset
.word 1520+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite hats, frame 0 (64x16 - 16 colors)
sprite_hats_0:
.byte 6, 3	; x- and y-offset
.word 1524+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+6	;h, w, palette index

; Sprite hats, frame 1 (64x32 - 16 colors)
sprite_hats_1:
.byte 10, 0	; x- and y-offset
.word 1540+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+7	;h, w, palette index

; Sprite hats, frame 2 (64x32 - 16 colors)
sprite_hats_2:
.byte 6, 6	; x- and y-offset
.word 1572+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite hats, frame 3 (64x32 - 16 colors)
sprite_hats_3:
.byte 0, 5	; x- and y-offset
.word 1604+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+5	;h, w, palette index

; Sprite hats, frame 4 (32x16 - 16 colors)
sprite_hats_4:
.byte 11, 15	; x- and y-offset
.word 1636+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+10	;h, w, palette index

; Sprite hats, frame 5 (64x32 - 16 colors)
sprite_hats_5:
.byte 6, 8	; x- and y-offset
.word 1644+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+6	;h, w, palette index

; Sprite mouths, frame 0 (32x16 - 16 colors)
sprite_mouths_0:
.byte 10, 6	; x- and y-offset
.word 1676+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+0	;h, w, palette index

; Sprite mouths, frame 1 (32x8 - 16 colors)
sprite_mouths_1:
.byte 14, 4	; x- and y-offset
.word 1684+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite mouths, frame 2 (8x8 - 16 colors)
sprite_mouths_2:
.byte 20, 13	; x- and y-offset
.word 27+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite mouths, frame 3 (16x8 - 16 colors)
sprite_mouths_3:
.byte 17, 12	; x- and y-offset
.word 1688+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+0	;h, w, palette index

; Sprite mouths, frame 4 (8x8 - 16 colors)
sprite_mouths_4:
.byte 22, 13	; x- and y-offset
.word 31+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite mouths, frame 5 (32x8 - 16 colors)
sprite_mouths_5:
.byte 12, 9	; x- and y-offset
.word 1690+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

