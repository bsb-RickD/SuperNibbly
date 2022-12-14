; Sprite smoke, frame 0 (8x16 - 16 colors)
sprite_smoke_0:
.byte 4, 3	; x- and y-offset
.word 124+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite smoke, frame 1 (8x16 - 16 colors)
sprite_smoke_1:
.byte 3, 3	; x- and y-offset
.word 126+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite smoke, frame 2 (8x16 - 16 colors)
sprite_smoke_2:
.byte 3, 2	; x- and y-offset
.word 646+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite smoke, frame 3 (8x16 - 16 colors)
sprite_smoke_3:
.byte 3, 2	; x- and y-offset
.word 648+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite smoke, frame 4 (8x16 - 16 colors)
sprite_smoke_4:
.byte 4, 1	; x- and y-offset
.word 650+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite smoke, frame 5 (8x16 - 16 colors)
sprite_smoke_5:
.byte 3, 1	; x- and y-offset
.word 652+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+1	;h, w, palette index

; Sprite fish, frame 0 (8x8 - 16 colors)
sprite_fish_0:
.byte 8, 6	; x- and y-offset
.word 3+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 1 (16x8 - 16 colors)
sprite_fish_1:
.byte 5, 4	; x- and y-offset
.word 654+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 2 (16x8 - 16 colors)
sprite_fish_2:
.byte 4, 2	; x- and y-offset
.word 656+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 3 (16x8 - 16 colors)
sprite_fish_3:
.byte 3, 1	; x- and y-offset
.word 658+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 4 (16x16 - 16 colors)
sprite_fish_4:
.byte 4, 0	; x- and y-offset
.word 660+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 5 (8x8 - 16 colors)
sprite_fish_5:
.byte 8, 0	; x- and y-offset
.word 7+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 6 (8x8 - 16 colors)
sprite_fish_6:
.byte 9, 0	; x- and y-offset
.word 11+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 7 (8x8 - 16 colors)
sprite_fish_7:
.byte 10, 0	; x- and y-offset
.word 15+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 8 (8x8 - 16 colors)
sprite_fish_8:
.byte 12, 1	; x- and y-offset
.word 19+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 9 (8x8 - 16 colors)
sprite_fish_9:
.byte 11, 3	; x- and y-offset
.word 23+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+3	;h, w, palette index

; Sprite fish, frame 10 (16x8 - 16 colors)
sprite_fish_10:
.byte 9, 5	; x- and y-offset
.word 664+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 11 (16x8 - 16 colors)
sprite_fish_11:
.byte 7, 6	; x- and y-offset
.word 666+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite fish, frame 12 (32x8 - 16 colors)
sprite_fish_12:
.byte 5, 6	; x- and y-offset
.word 668+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+3	;h, w, palette index

; Sprite fish, frame 13 (32x8 - 16 colors)
sprite_fish_13:
.byte 4, 5	; x- and y-offset
.word 672+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+3	;h, w, palette index

; Sprite fish, frame 14 (32x8 - 16 colors)
sprite_fish_14:
.byte 4, 5	; x- and y-offset
.word 676+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+3	;h, w, palette index

; Sprite fish, frame 15 (32x8 - 16 colors)
sprite_fish_15:
.byte 3, 5	; x- and y-offset
.word 680+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+3	;h, w, palette index

; Sprite fish, frame 16 (32x8 - 16 colors)
sprite_fish_16:
.byte 2, 5	; x- and y-offset
.word 684+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+3	;h, w, palette index

; Sprite plane, frame 0 (16x8 - 16 colors)
sprite_plane_0:
.byte 2, 4	; x- and y-offset
.word 688+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 1 (16x8 - 16 colors)
sprite_plane_1:
.byte 2, 3	; x- and y-offset
.word 690+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 2 (16x16 - 16 colors)
sprite_plane_2:
.byte 3, 2	; x- and y-offset
.word 692+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 3 (8x16 - 16 colors)
sprite_plane_3:
.byte 5, 1	; x- and y-offset
.word 696+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 4 (8x16 - 16 colors)
sprite_plane_4:
.byte 6, 0	; x- and y-offset
.word 698+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 5 (8x16 - 16 colors)
sprite_plane_5:
.byte 6, 0	; x- and y-offset
.word 700+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 6 (16x16 - 16 colors)
sprite_plane_6:
.byte 4, 1	; x- and y-offset
.word 702+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 7 (16x8 - 16 colors)
sprite_plane_7:
.byte 3, 3	; x- and y-offset
.word 706+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 8 (16x8 - 16 colors)
sprite_plane_8:
.byte 2, 3	; x- and y-offset
.word 708+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 9 (16x8 - 16 colors)
sprite_plane_9:
.byte 3, 3	; x- and y-offset
.word 710+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 10 (16x16 - 16 colors)
sprite_plane_10:
.byte 4, 3	; x- and y-offset
.word 712+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 11 (8x16 - 16 colors)
sprite_plane_11:
.byte 5, 1	; x- and y-offset
.word 716+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 12 (8x16 - 16 colors)
sprite_plane_12:
.byte 6, 0	; x- and y-offset
.word 718+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 13 (8x16 - 16 colors)
sprite_plane_13:
.byte 5, 0	; x- and y-offset
.word 720+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+3	;h, w, palette index

; Sprite plane, frame 14 (16x16 - 16 colors)
sprite_plane_14:
.byte 4, 1	; x- and y-offset
.word 722+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite plane, frame 15 (16x8 - 16 colors)
sprite_plane_15:
.byte 3, 2	; x- and y-offset
.word 726+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+3	;h, w, palette index

; Sprite n_0, frame 0 (64x64 - 16 colors)
sprite_n_0_0:
.byte 0, 0	; x- and y-offset
.word 728+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite n_1, frame 0 (64x32 - 16 colors)
sprite_n_1_0:
.byte 0, 64	; x- and y-offset
.word 792+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite i_0, frame 0 (32x64 - 16 colors)
sprite_i_0_0:
.byte 0, 0	; x- and y-offset
.word 824+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+4	;h, w, palette index

; Sprite i_1, frame 0 (32x8 - 16 colors)
sprite_i_1_0:
.byte 0, 64	; x- and y-offset
.word 856+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite b1_0, frame 0 (64x64 - 16 colors)
sprite_b1_0_0:
.byte 0, 0	; x- and y-offset
.word 860+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b1_1, frame 0 (64x16 - 16 colors)
sprite_b1_1_0:
.byte 0, 64	; x- and y-offset
.word 924+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b2_0, frame 0 (64x64 - 16 colors)
sprite_b2_0_0:
.byte 0, 0	; x- and y-offset
.word 940+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite b2_1, frame 0 (64x8 - 16 colors)
sprite_b2_1_0:
.byte 0, 64	; x- and y-offset
.word 1004+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_64+4	;h, w, palette index

; Sprite l_0, frame 0 (64x64 - 16 colors)
sprite_l_0_0:
.byte 0, 0	; x- and y-offset
.word 1012+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite l_1, frame 0 (64x16 - 16 colors)
sprite_l_1_0:
.byte 0, 64	; x- and y-offset
.word 1076+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite y_0, frame 0 (64x64 - 16 colors)
sprite_y_0_0:
.byte 0, 0	; x- and y-offset
.word 1092+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+4	;h, w, palette index

; Sprite y_1, frame 0 (64x32 - 16 colors)
sprite_y_1_0:
.byte 0, 64	; x- and y-offset
.word 1156+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

