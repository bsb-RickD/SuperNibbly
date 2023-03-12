; Sprite head, frame 0 (64x64 - 16 colors)
sprite_head_0:
.byte 6, 10	; x- and y-offset
.word 1255+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+0	;h, w, palette index

; Sprite necks, frame 0 (32x64 - 16 colors)
sprite_necks_0:
.byte 2, 5	; x- and y-offset
.word 1319+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+1	;h, w, palette index

; Sprite necks, frame 1 (64x64 - 16 colors)
sprite_necks_1:
.byte 0, 0	; x- and y-offset
.word 1351+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite necks, frame 2 (64x64 - 16 colors)
sprite_necks_2:
.byte 2, 0	; x- and y-offset
.word 1415+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+1	;h, w, palette index

; Sprite eyes_blinking, frame 0 (32x8 - 16 colors)
sprite_eyes_blinking_0:
.byte 0, 1	; x- and y-offset
.word 1479+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 1 (32x8 - 16 colors)
sprite_eyes_blinking_1:
.byte 0, 1	; x- and y-offset
.word 1483+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 2 (32x8 - 16 colors)
sprite_eyes_blinking_2:
.byte 0, 1	; x- and y-offset
.word 1487+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 3 (32x8 - 16 colors)
sprite_eyes_blinking_3:
.byte 0, 1	; x- and y-offset
.word 1491+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 4 (32x8 - 16 colors)
sprite_eyes_blinking_4:
.byte 0, 1	; x- and y-offset
.word 1495+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 5 (32x8 - 16 colors)
sprite_eyes_blinking_5:
.byte 0, 1	; x- and y-offset
.word 1499+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 6 (32x8 - 16 colors)
sprite_eyes_blinking_6:
.byte 0, 1	; x- and y-offset
.word 1503+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 7 (32x8 - 16 colors)
sprite_eyes_blinking_7:
.byte 0, 1	; x- and y-offset
.word 1507+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 8 (32x8 - 16 colors)
sprite_eyes_blinking_8:
.byte 0, 1	; x- and y-offset
.word 1511+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 9 (32x8 - 16 colors)
sprite_eyes_blinking_9:
.byte 0, 1	; x- and y-offset
.word 1515+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 10 (32x8 - 16 colors)
sprite_eyes_blinking_10:
.byte 0, 1	; x- and y-offset
.word 1519+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 11 (32x8 - 16 colors)
sprite_eyes_blinking_11:
.byte 0, 1	; x- and y-offset
.word 1523+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 12 (32x8 - 16 colors)
sprite_eyes_blinking_12:
.byte 0, 1	; x- and y-offset
.word 1527+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 13 (32x8 - 16 colors)
sprite_eyes_blinking_13:
.byte 0, 1	; x- and y-offset
.word 1531+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 14 (32x8 - 16 colors)
sprite_eyes_blinking_14:
.byte 0, 1	; x- and y-offset
.word 1535+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 15 (32x8 - 16 colors)
sprite_eyes_blinking_15:
.byte 0, 1	; x- and y-offset
.word 1539+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 16 (32x8 - 16 colors)
sprite_eyes_blinking_16:
.byte 0, 1	; x- and y-offset
.word 1543+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 17 (32x8 - 16 colors)
sprite_eyes_blinking_17:
.byte 0, 1	; x- and y-offset
.word 1547+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite eyes_blinking, frame 18 (32x8 - 16 colors)
sprite_eyes_blinking_18:
.byte 0, 1	; x- and y-offset
.word 1551+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite hats, frame 0 (64x16 - 16 colors)
sprite_hats_0:
.byte 6, 3	; x- and y-offset
.word 1555+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite hats, frame 1 (64x32 - 16 colors)
sprite_hats_1:
.byte 10, 0	; x- and y-offset
.word 1571+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+12	;h, w, palette index

; Sprite hats, frame 2 (64x16 - 16 colors)
sprite_hats_2:
.byte 6, 6	; x- and y-offset
.word 1603+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+2	;h, w, palette index

; Sprite hats, frame 3 (64x16 - 16 colors)
sprite_hats_3:
.byte 0, 6	; x- and y-offset
.word 1619+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+14	;h, w, palette index

; Sprite hats, frame 4 (32x16 - 16 colors)
sprite_hats_4:
.byte 11, 15	; x- and y-offset
.word 1635+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+10	;h, w, palette index

; Sprite hats, frame 5 (64x32 - 16 colors)
sprite_hats_5:
.byte 6, 8	; x- and y-offset
.word 1643+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite mouths, frame 0 (32x16 - 16 colors)
sprite_mouths_0:
.byte 10, 6	; x- and y-offset
.word 1675+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+0	;h, w, palette index

; Sprite mouths, frame 1 (32x8 - 16 colors)
sprite_mouths_1:
.byte 14, 4	; x- and y-offset
.word 1683+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+2	;h, w, palette index

; Sprite mouths, frame 2 (8x8 - 16 colors)
sprite_mouths_2:
.byte 20, 13	; x- and y-offset
.word 1687+VERA_sprite_colors_16	; address/32 (+ color indicator) 
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
.word 1690+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite mouths, frame 5 (32x8 - 16 colors)
sprite_mouths_5:
.byte 12, 9	; x- and y-offset
.word 1691+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bubbles, frame 0, part 0  (64x32 - 16 colors)
sprite_bubbles_0_0:
.byte 0, 0	; x- and y-offset
.word 1695+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+2	;h, w, palette index

; Sprite bubbles, frame 0, part 1  (16x32 - 16 colors)
sprite_bubbles_0_1:
.byte 64, 1	; x- and y-offset
.word 1727+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+2	;h, w, palette index

; Sprite bubbles, frame 0, part 2  (64x16 - 16 colors)
sprite_bubbles_0_2:
.byte 0, 32	; x- and y-offset
.word 1735+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 0, part 3  (16x16 - 16 colors)
sprite_bubbles_0_3:
.byte 64, 32	; x- and y-offset
.word 1751+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 1, part 0  (64x32 - 16 colors)
sprite_bubbles_1_0:
.byte 0, 0	; x- and y-offset
.word 1755+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+2	;h, w, palette index

; Sprite bubbles, frame 1, part 1  (16x32 - 16 colors)
sprite_bubbles_1_1:
.byte 64, 1	; x- and y-offset
.word 1787+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+2	;h, w, palette index

; Sprite bubbles, frame 1, part 2  (64x16 - 16 colors)
sprite_bubbles_1_2:
.byte 0, 32	; x- and y-offset
.word 1795+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 1, part 3  (16x16 - 16 colors)
sprite_bubbles_1_3:
.byte 64, 32	; x- and y-offset
.word 1811+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 2, part 0  (64x32 - 16 colors)
sprite_bubbles_2_0:
.byte 0, 0	; x- and y-offset
.word 1815+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 2, part 1  (16x32 - 16 colors)
sprite_bubbles_2_1:
.byte 64, 1	; x- and y-offset
.word 1847+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 2, part 2  (64x16 - 16 colors)
sprite_bubbles_2_2:
.byte 0, 32	; x- and y-offset
.word 1855+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 2, part 3  (16x16 - 16 colors)
sprite_bubbles_2_3:
.byte 64, 32	; x- and y-offset
.word 1871+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 3, part 0  (64x32 - 16 colors)
sprite_bubbles_3_0:
.byte 0, 0	; x- and y-offset
.word 1875+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+2	;h, w, palette index

; Sprite bubbles, frame 3, part 1  (16x32 - 16 colors)
sprite_bubbles_3_1:
.byte 64, 1	; x- and y-offset
.word 1907+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+2	;h, w, palette index

; Sprite bubbles, frame 3, part 2  (64x16 - 16 colors)
sprite_bubbles_3_2:
.byte 0, 32	; x- and y-offset
.word 1915+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 3, part 3  (16x16 - 16 colors)
sprite_bubbles_3_3:
.byte 64, 32	; x- and y-offset
.word 1931+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 4, part 0  (64x32 - 16 colors)
sprite_bubbles_4_0:
.byte 0, 0	; x- and y-offset
.word 1935+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+2	;h, w, palette index

; Sprite bubbles, frame 4, part 1  (16x32 - 16 colors)
sprite_bubbles_4_1:
.byte 64, 1	; x- and y-offset
.word 1967+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 4, part 2  (64x16 - 16 colors)
sprite_bubbles_4_2:
.byte 0, 32	; x- and y-offset
.word 1975+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 4, part 3  (16x16 - 16 colors)
sprite_bubbles_4_3:
.byte 64, 32	; x- and y-offset
.word 1991+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 5, part 0  (64x32 - 16 colors)
sprite_bubbles_5_0:
.byte 0, 0	; x- and y-offset
.word 1995+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+2	;h, w, palette index

; Sprite bubbles, frame 5, part 1  (16x32 - 16 colors)
sprite_bubbles_5_1:
.byte 64, 1	; x- and y-offset
.word 2027+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+2	;h, w, palette index

; Sprite bubbles, frame 5, part 2  (64x16 - 16 colors)
sprite_bubbles_5_2:
.byte 0, 32	; x- and y-offset
.word 2035+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 5, part 3  (16x16 - 16 colors)
sprite_bubbles_5_3:
.byte 64, 32	; x- and y-offset
.word 2051+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 6, part 0  (64x32 - 16 colors)
sprite_bubbles_6_0:
.byte 0, 0	; x- and y-offset
.word 2055+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 6, part 1  (16x32 - 16 colors)
sprite_bubbles_6_1:
.byte 64, 1	; x- and y-offset
.word 2087+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+4	;h, w, palette index

; Sprite bubbles, frame 6, part 2  (64x16 - 16 colors)
sprite_bubbles_6_2:
.byte 0, 32	; x- and y-offset
.word 2095+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite bubbles, frame 6, part 3  (16x16 - 16 colors)
sprite_bubbles_6_3:
.byte 64, 32	; x- and y-offset
.word 2111+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite thinking, frame 0 (32x32 - 16 colors)
sprite_thinking_0:
.byte 0, 0	; x- and y-offset
.word 2115+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+2	;h, w, palette index

; Sprite jf_son, frame 0 (16x32 - 16 colors)
sprite_jf_son_0:
.byte 0, 0	; x- and y-offset
.word 2131+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+3	;h, w, palette index

; Sprite 45degree, frame 0, part 0  (64x64 - 16 colors)
sprite_45degree_0_0:
.byte 0, 0	; x- and y-offset
.word 2139+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+3	;h, w, palette index

; Sprite 45degree, frame 0, part 1  (16x16 - 16 colors)
sprite_45degree_0_1:
.byte 41, 64	; x- and y-offset
.word 2203+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+1	;h, w, palette index

; Sprite 45deg_blinking, frame 0 (16x16 - 16 colors)
sprite_45deg_blinking_0:
.byte 0, 1	; x- and y-offset
.word 2207+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite 45deg_blinking, frame 1 (16x16 - 16 colors)
sprite_45deg_blinking_1:
.byte 0, 1	; x- and y-offset
.word 2211+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite 45deg_blinking, frame 2 (16x16 - 16 colors)
sprite_45deg_blinking_2:
.byte 0, 1	; x- and y-offset
.word 2215+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite 45deg_blinking, frame 3 (16x16 - 16 colors)
sprite_45deg_blinking_3:
.byte 0, 1	; x- and y-offset
.word 2219+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite mum, frame 0 (32x32 - 16 colors)
sprite_mum_0:
.byte 0, 0	; x- and y-offset
.word 2223+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+10	;h, w, palette index

; Sprite bigmum, frame 0, part 0  (64x64 - 16 colors)
sprite_bigmum_0_0:
.byte 0, 0	; x- and y-offset
.word 2239+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+10	;h, w, palette index

; Sprite head_crash, frame 0 (64x16 - 16 colors)
sprite_head_crash_0:
.byte 0, 2	; x- and y-offset
.word 2303+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite jf_fat, frame 0, part 0  (64x32 - 16 colors)
sprite_jf_fat_0_0:
.byte 1, 0	; x- and y-offset
.word 2319+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+1	;h, w, palette index

; Sprite jf_fat, frame 0, part 1  (16x32 - 16 colors)
sprite_jf_fat_0_1:
.byte 64, 13	; x- and y-offset
.word 2351+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+1	;h, w, palette index

; Sprite zack, frame 0 (64x32 - 16 colors)
sprite_zack_0:
.byte 0, 0	; x- and y-offset
.word 2359+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+4	;h, w, palette index

; Sprite toff_crash_slup, frame 0 (32x8 - 16 colors)
sprite_toff_crash_slup_0:
.byte 0, 1	; x- and y-offset
.word 2391+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite toff_crash_slup, frame 1 (32x8 - 16 colors)
sprite_toff_crash_slup_1:
.byte 0, 1	; x- and y-offset
.word 2395+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite toff_crash_slup, frame 2 (32x8 - 16 colors)
sprite_toff_crash_slup_2:
.byte 0, 1	; x- and y-offset
.word 2399+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite debris_hat, frame 0 (32x32 - 16 colors)
sprite_debris_hat_0:
.byte 0, 0	; x- and y-offset
.word 2403+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+4	;h, w, palette index

; Sprite debris_tail, frame 0 (32x16 - 16 colors)
sprite_debris_tail_0:
.byte 0, 1	; x- and y-offset
.word 2419+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+5	;h, w, palette index

; Sprite debris_prop, frame 0 (32x32 - 16 colors)
sprite_debris_prop_0:
.byte 1, 1	; x- and y-offset
.word 2427+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+4	;h, w, palette index

; Sprite debris_wing, frame 0, part 0  (32x16 - 16 colors)
sprite_debris_wing_0_0:
.byte 0, 3	; x- and y-offset
.word 2443+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+5	;h, w, palette index

; Sprite debris_wing, frame 0, part 1  (16x16 - 16 colors)
sprite_debris_wing_0_1:
.byte 32, 7	; x- and y-offset
.word 2451+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite propeller, frame 0 (8x64 - 16 colors)
sprite_propeller_0:
.byte 2, 0	; x- and y-offset
.word 2455+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_8+12	;h, w, palette index

; Sprite propeller, frame 1 (8x32 - 16 colors)
sprite_propeller_1:
.byte 2, 10	; x- and y-offset
.word 2463+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_8+12	;h, w, palette index

; Sprite propeller, frame 2 (8x8 - 16 colors)
sprite_propeller_2:
.byte 2, 21	; x- and y-offset
.word 2467+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+12	;h, w, palette index

; Sprite t1000, frame 0, part 0  (16x16 - 16 colors)
sprite_t1000_0_0:
.byte 18, 22	; x- and y-offset
.word 2468+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+6	;h, w, palette index

; Sprite t1000, frame 0, part 1  (32x32 - 256 colors)
sprite_t1000_0_1:
.byte 32, 0	; x- and y-offset
.word 2472+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite t1000, frame 0, part 2  (16x32 - 16 colors)
sprite_t1000_0_2:
.byte 64, 14	; x- and y-offset
.word 2504+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+0	;h, w, palette index

; Sprite t1000, frame 0, part 3  (32x32 - 256 colors)
sprite_t1000_0_3:
.byte 1, 32	; x- and y-offset
.word 2512+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite t1000, frame 0, part 4  (32x32 - 16 colors)
sprite_t1000_0_4:
.byte 32, 32	; x- and y-offset
.word 2544+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+1	;h, w, palette index

; Sprite t1000, frame 0, part 5  (16x16 - 16 colors)
sprite_t1000_0_5:
.byte 64, 32	; x- and y-offset
.word 2560+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+0	;h, w, palette index

; Sprite t1000, frame 0, part 6  (32x8 - 16 colors)
sprite_t1000_0_6:
.byte 0, 64	; x- and y-offset
.word 2564+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite bigplane, frame 0, part 0  (32x64 - 16 colors)
sprite_bigplane_0_0:
.byte 0, 23	; x- and y-offset
.word 2568+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+5	;h, w, palette index

; Sprite bigplane, frame 0, part 1  (32x64 - 256 colors)
sprite_bigplane_0_1:
.byte 32, 7	; x- and y-offset
.word 2600+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bigplane, frame 0, part 2  (32x64 - 256 colors)
sprite_bigplane_0_2:
.byte 64, 0	; x- and y-offset
.word 2664+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bigplane, frame 0, part 3  (8x64 - 16 colors)
sprite_bigplane_0_3:
.byte 96, 18	; x- and y-offset
.word 2728+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_8+11	;h, w, palette index

; Sprite bigplane, frame 0, part 4  (16x16 - 16 colors)
sprite_bigplane_0_4:
.byte 16, 64	; x- and y-offset
.word 2736+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite bigplane, frame 0, part 5  (32x16 - 16 colors)
sprite_bigplane_0_5:
.byte 32, 64	; x- and y-offset
.word 2740+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+5	;h, w, palette index

; Sprite bigplane, frame 0, part 6  (32x16 - 16 colors)
sprite_bigplane_0_6:
.byte 64, 64	; x- and y-offset
.word 2748+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+5	;h, w, palette index

