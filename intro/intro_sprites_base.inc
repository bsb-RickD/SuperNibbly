; Sprite smoke, frame 0 (8x16 - 16 colors)
sprite_smoke_0:
.byte 4, 3	; x- and y-offset
.word 124+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

; Sprite smoke, frame 1 (8x16 - 16 colors)
sprite_smoke_1:
.byte 3, 3	; x- and y-offset
.word 126+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

; Sprite smoke, frame 2 (8x16 - 16 colors)
sprite_smoke_2:
.byte 3, 2	; x- and y-offset
.word 645+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

; Sprite smoke, frame 3 (8x16 - 16 colors)
sprite_smoke_3:
.byte 3, 2	; x- and y-offset
.word 647+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

; Sprite smoke, frame 4 (8x16 - 16 colors)
sprite_smoke_4:
.byte 4, 1	; x- and y-offset
.word 649+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

; Sprite smoke, frame 5 (8x16 - 16 colors)
sprite_smoke_5:
.byte 3, 1	; x- and y-offset
.word 651+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+4	;h, w, palette index

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
.word 653+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+15	;h, w, palette index

; Sprite fish, frame 2 (16x8 - 16 colors)
sprite_fish_2:
.byte 4, 2	; x- and y-offset
.word 655+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+15	;h, w, palette index

; Sprite fish, frame 3 (16x8 - 16 colors)
sprite_fish_3:
.byte 3, 1	; x- and y-offset
.word 657+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+15	;h, w, palette index

; Sprite fish, frame 4 (16x16 - 16 colors)
sprite_fish_4:
.byte 4, 0	; x- and y-offset
.word 659+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+15	;h, w, palette index

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
.byte VERA_sprite_height_8+VERA_sprite_width_8+15	;h, w, palette index

; Sprite fish, frame 10 (16x8 - 16 colors)
sprite_fish_10:
.byte 9, 5	; x- and y-offset
.word 663+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+15	;h, w, palette index

; Sprite fish, frame 11 (16x8 - 16 colors)
sprite_fish_11:
.byte 7, 6	; x- and y-offset
.word 665+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+15	;h, w, palette index

; Sprite fish, frame 12 (32x8 - 16 colors)
sprite_fish_12:
.byte 5, 6	; x- and y-offset
.word 667+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+13	;h, w, palette index

; Sprite fish, frame 13 (32x8 - 16 colors)
sprite_fish_13:
.byte 4, 5	; x- and y-offset
.word 671+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+13	;h, w, palette index

; Sprite fish, frame 14 (32x8 - 16 colors)
sprite_fish_14:
.byte 4, 5	; x- and y-offset
.word 675+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+13	;h, w, palette index

; Sprite fish, frame 15 (32x8 - 16 colors)
sprite_fish_15:
.byte 3, 5	; x- and y-offset
.word 679+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+13	;h, w, palette index

; Sprite fish, frame 16 (32x8 - 16 colors)
sprite_fish_16:
.byte 2, 5	; x- and y-offset
.word 683+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+13	;h, w, palette index

; Sprite plane, frame 0 (16x8 - 16 colors)
sprite_plane_0:
.byte 2, 4	; x- and y-offset
.word 687+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 1 (16x8 - 16 colors)
sprite_plane_1:
.byte 2, 3	; x- and y-offset
.word 689+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 2 (16x16 - 16 colors)
sprite_plane_2:
.byte 3, 2	; x- and y-offset
.word 691+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 3 (8x16 - 16 colors)
sprite_plane_3:
.byte 5, 1	; x- and y-offset
.word 695+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 4 (8x16 - 16 colors)
sprite_plane_4:
.byte 6, 0	; x- and y-offset
.word 697+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 5 (8x16 - 16 colors)
sprite_plane_5:
.byte 6, 0	; x- and y-offset
.word 699+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 6 (16x16 - 16 colors)
sprite_plane_6:
.byte 4, 1	; x- and y-offset
.word 701+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 7 (16x8 - 16 colors)
sprite_plane_7:
.byte 3, 3	; x- and y-offset
.word 705+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 8 (16x8 - 16 colors)
sprite_plane_8:
.byte 2, 3	; x- and y-offset
.word 707+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 9 (16x8 - 16 colors)
sprite_plane_9:
.byte 3, 3	; x- and y-offset
.word 709+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 10 (16x16 - 16 colors)
sprite_plane_10:
.byte 4, 3	; x- and y-offset
.word 711+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 11 (8x16 - 16 colors)
sprite_plane_11:
.byte 5, 1	; x- and y-offset
.word 715+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 12 (8x16 - 16 colors)
sprite_plane_12:
.byte 6, 0	; x- and y-offset
.word 717+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 13 (8x16 - 16 colors)
sprite_plane_13:
.byte 5, 0	; x- and y-offset
.word 719+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+13	;h, w, palette index

; Sprite plane, frame 14 (16x16 - 16 colors)
sprite_plane_14:
.byte 4, 1	; x- and y-offset
.word 721+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+13	;h, w, palette index

; Sprite plane, frame 15 (16x8 - 16 colors)
sprite_plane_15:
.byte 3, 2	; x- and y-offset
.word 725+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+13	;h, w, palette index

; Sprite n, frame 0, part 0  (64x64 - 16 colors)
sprite_n_0_0:
.byte 0, 0	; x- and y-offset
.word 727+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite n, frame 0, part 1  (64x32 - 16 colors)
sprite_n_0_1:
.byte 0, 64	; x- and y-offset
.word 791+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+10	;h, w, palette index

; Sprite i, frame 0, part 0  (32x64 - 16 colors)
sprite_i_0_0:
.byte 0, 0	; x- and y-offset
.word 823+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+10	;h, w, palette index

; Sprite i, frame 0, part 1  (32x8 - 16 colors)
sprite_i_0_1:
.byte 0, 64	; x- and y-offset
.word 855+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+10	;h, w, palette index

; Sprite b1, frame 0, part 0  (64x64 - 16 colors)
sprite_b1_0_0:
.byte 0, 0	; x- and y-offset
.word 859+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite b1, frame 0, part 1  (64x16 - 16 colors)
sprite_b1_0_1:
.byte 0, 64	; x- and y-offset
.word 923+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+10	;h, w, palette index

; Sprite b2, frame 0, part 0  (64x64 - 16 colors)
sprite_b2_0_0:
.byte 0, 0	; x- and y-offset
.word 939+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite b2, frame 0, part 1  (64x8 - 16 colors)
sprite_b2_0_1:
.byte 0, 64	; x- and y-offset
.word 1003+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_64+10	;h, w, palette index

; Sprite l, frame 0, part 0  (64x64 - 16 colors)
sprite_l_0_0:
.byte 0, 0	; x- and y-offset
.word 1011+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite l, frame 0, part 1  (64x16 - 16 colors)
sprite_l_0_1:
.byte 0, 64	; x- and y-offset
.word 1075+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+10	;h, w, palette index

; Sprite y, frame 0, part 0  (64x64 - 16 colors)
sprite_y_0_0:
.byte 0, 0	; x- and y-offset
.word 1091+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite y, frame 0, part 1  (64x32 - 16 colors)
sprite_y_0_1:
.byte 0, 64	; x- and y-offset
.word 1155+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+10	;h, w, palette index
