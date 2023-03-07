; Sprite head, frame 0 (64x64 - 16 colors)
sprite_head_0:
.byte 6, 10	; x- and y-offset
.word 1197+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+5	;h, w, palette index

; Sprite necks, frame 0 (32x64 - 16 colors)
sprite_necks_0:
.byte 2, 5	; x- and y-offset
.word 1261+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+6	;h, w, palette index

; Sprite necks, frame 1 (64x64 - 16 colors)
sprite_necks_1:
.byte 0, 0	; x- and y-offset
.word 1293+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+6	;h, w, palette index

; Sprite necks, frame 2 (64x64 - 16 colors)
sprite_necks_2:
.byte 2, 0	; x- and y-offset
.word 1357+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+6	;h, w, palette index

; Sprite eyes_blinking, frame 0 (32x8 - 16 colors)
sprite_eyes_blinking_0:
.byte 0, 1	; x- and y-offset
.word 1421+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 1 (32x8 - 16 colors)
sprite_eyes_blinking_1:
.byte 0, 1	; x- and y-offset
.word 1425+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 2 (32x8 - 16 colors)
sprite_eyes_blinking_2:
.byte 0, 1	; x- and y-offset
.word 1429+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 3 (32x8 - 16 colors)
sprite_eyes_blinking_3:
.byte 0, 1	; x- and y-offset
.word 1433+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 4 (32x8 - 16 colors)
sprite_eyes_blinking_4:
.byte 0, 1	; x- and y-offset
.word 1437+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 5 (32x8 - 16 colors)
sprite_eyes_blinking_5:
.byte 0, 1	; x- and y-offset
.word 1441+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 6 (32x8 - 16 colors)
sprite_eyes_blinking_6:
.byte 0, 1	; x- and y-offset
.word 1445+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 7 (32x8 - 16 colors)
sprite_eyes_blinking_7:
.byte 0, 1	; x- and y-offset
.word 1449+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 8 (32x8 - 16 colors)
sprite_eyes_blinking_8:
.byte 0, 1	; x- and y-offset
.word 1453+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 9 (32x8 - 16 colors)
sprite_eyes_blinking_9:
.byte 0, 1	; x- and y-offset
.word 1457+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 10 (32x8 - 16 colors)
sprite_eyes_blinking_10:
.byte 0, 1	; x- and y-offset
.word 1461+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 11 (32x8 - 16 colors)
sprite_eyes_blinking_11:
.byte 0, 1	; x- and y-offset
.word 1465+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 12 (32x8 - 16 colors)
sprite_eyes_blinking_12:
.byte 0, 1	; x- and y-offset
.word 1469+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 13 (32x8 - 16 colors)
sprite_eyes_blinking_13:
.byte 0, 1	; x- and y-offset
.word 1473+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 14 (32x8 - 16 colors)
sprite_eyes_blinking_14:
.byte 0, 1	; x- and y-offset
.word 1477+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 15 (32x8 - 16 colors)
sprite_eyes_blinking_15:
.byte 0, 1	; x- and y-offset
.word 1481+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 16 (32x8 - 16 colors)
sprite_eyes_blinking_16:
.byte 0, 1	; x- and y-offset
.word 1485+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 17 (32x8 - 16 colors)
sprite_eyes_blinking_17:
.byte 0, 1	; x- and y-offset
.word 1489+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite eyes_blinking, frame 18 (32x8 - 16 colors)
sprite_eyes_blinking_18:
.byte 0, 1	; x- and y-offset
.word 1493+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite hats, frame 0 (64x16 - 16 colors)
sprite_hats_0:
.byte 6, 3	; x- and y-offset
.word 1497+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite hats, frame 1 (64x32 - 16 colors)
sprite_hats_1:
.byte 10, 0	; x- and y-offset
.word 1513+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+8	;h, w, palette index

; Sprite hats, frame 2 (64x16 - 16 colors)
sprite_hats_2:
.byte 6, 6	; x- and y-offset
.word 1545+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+0	;h, w, palette index

; Sprite hats, frame 3 (64x16 - 16 colors)
sprite_hats_3:
.byte 0, 6	; x- and y-offset
.word 1561+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+1	;h, w, palette index

; Sprite hats, frame 4 (32x16 - 16 colors)
sprite_hats_4:
.byte 11, 15	; x- and y-offset
.word 1577+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+15	;h, w, palette index

; Sprite hats, frame 5 (64x32 - 16 colors)
sprite_hats_5:
.byte 6, 8	; x- and y-offset
.word 1585+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+12	;h, w, palette index

; Sprite mouths, frame 0 (32x16 - 16 colors)
sprite_mouths_0:
.byte 10, 6	; x- and y-offset
.word 1617+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+0	;h, w, palette index

; Sprite mouths, frame 1 (32x8 - 16 colors)
sprite_mouths_1:
.byte 14, 4	; x- and y-offset
.word 1625+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite mouths, frame 2 (8x8 - 16 colors)
sprite_mouths_2:
.byte 20, 13	; x- and y-offset
.word 1629+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite mouths, frame 3 (16x8 - 16 colors)
sprite_mouths_3:
.byte 17, 12	; x- and y-offset
.word 1630+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+0	;h, w, palette index

; Sprite mouths, frame 4 (8x8 - 16 colors)
sprite_mouths_4:
.byte 22, 13	; x- and y-offset
.word 1632+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+0	;h, w, palette index

; Sprite mouths, frame 5 (32x8 - 16 colors)
sprite_mouths_5:
.byte 12, 9	; x- and y-offset
.word 1633+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bubbles, frame 0, part 0  (64x32 - 16 colors)
sprite_bubbles_0_0:
.byte 0, 0	; x- and y-offset
.word 1637+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite bubbles, frame 0, part 1  (16x32 - 16 colors)
sprite_bubbles_0_1:
.byte 64, 1	; x- and y-offset
.word 1669+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+0	;h, w, palette index

; Sprite bubbles, frame 0, part 2  (64x16 - 16 colors)
sprite_bubbles_0_2:
.byte 0, 32	; x- and y-offset
.word 1677+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 0, part 3  (16x16 - 16 colors)
sprite_bubbles_0_3:
.byte 64, 32	; x- and y-offset
.word 1693+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 1, part 0  (64x32 - 16 colors)
sprite_bubbles_1_0:
.byte 0, 0	; x- and y-offset
.word 1697+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite bubbles, frame 1, part 1  (16x32 - 16 colors)
sprite_bubbles_1_1:
.byte 64, 1	; x- and y-offset
.word 1729+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+0	;h, w, palette index

; Sprite bubbles, frame 1, part 2  (64x16 - 16 colors)
sprite_bubbles_1_2:
.byte 0, 32	; x- and y-offset
.word 1737+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 1, part 3  (16x16 - 16 colors)
sprite_bubbles_1_3:
.byte 64, 32	; x- and y-offset
.word 1753+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 2, part 0  (64x32 - 16 colors)
sprite_bubbles_2_0:
.byte 0, 0	; x- and y-offset
.word 1757+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 2, part 1  (16x32 - 16 colors)
sprite_bubbles_2_1:
.byte 64, 1	; x- and y-offset
.word 1789+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+7	;h, w, palette index

; Sprite bubbles, frame 2, part 2  (64x16 - 16 colors)
sprite_bubbles_2_2:
.byte 0, 32	; x- and y-offset
.word 1797+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 2, part 3  (16x16 - 16 colors)
sprite_bubbles_2_3:
.byte 64, 32	; x- and y-offset
.word 1813+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 3, part 0  (64x32 - 16 colors)
sprite_bubbles_3_0:
.byte 0, 0	; x- and y-offset
.word 1817+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite bubbles, frame 3, part 1  (16x32 - 16 colors)
sprite_bubbles_3_1:
.byte 64, 1	; x- and y-offset
.word 1849+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+0	;h, w, palette index

; Sprite bubbles, frame 3, part 2  (64x16 - 16 colors)
sprite_bubbles_3_2:
.byte 0, 32	; x- and y-offset
.word 1857+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 3, part 3  (16x16 - 16 colors)
sprite_bubbles_3_3:
.byte 64, 32	; x- and y-offset
.word 1873+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 4, part 0  (64x32 - 16 colors)
sprite_bubbles_4_0:
.byte 0, 0	; x- and y-offset
.word 1877+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite bubbles, frame 4, part 1  (16x32 - 16 colors)
sprite_bubbles_4_1:
.byte 64, 1	; x- and y-offset
.word 1909+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+7	;h, w, palette index

; Sprite bubbles, frame 4, part 2  (64x16 - 16 colors)
sprite_bubbles_4_2:
.byte 0, 32	; x- and y-offset
.word 1917+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 4, part 3  (16x16 - 16 colors)
sprite_bubbles_4_3:
.byte 64, 32	; x- and y-offset
.word 1933+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 5, part 0  (64x32 - 16 colors)
sprite_bubbles_5_0:
.byte 0, 0	; x- and y-offset
.word 1937+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+0	;h, w, palette index

; Sprite bubbles, frame 5, part 1  (16x32 - 16 colors)
sprite_bubbles_5_1:
.byte 64, 1	; x- and y-offset
.word 1969+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+0	;h, w, palette index

; Sprite bubbles, frame 5, part 2  (64x16 - 16 colors)
sprite_bubbles_5_2:
.byte 0, 32	; x- and y-offset
.word 1977+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 5, part 3  (16x16 - 16 colors)
sprite_bubbles_5_3:
.byte 64, 32	; x- and y-offset
.word 1993+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite bubbles, frame 6, part 0  (64x32 - 16 colors)
sprite_bubbles_6_0:
.byte 0, 0	; x- and y-offset
.word 1997+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 6, part 1  (16x32 - 16 colors)
sprite_bubbles_6_1:
.byte 64, 1	; x- and y-offset
.word 2029+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+7	;h, w, palette index

; Sprite bubbles, frame 6, part 2  (64x16 - 16 colors)
sprite_bubbles_6_2:
.byte 0, 32	; x- and y-offset
.word 2037+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+12	;h, w, palette index

; Sprite bubbles, frame 6, part 3  (16x16 - 16 colors)
sprite_bubbles_6_3:
.byte 64, 32	; x- and y-offset
.word 2053+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+12	;h, w, palette index

; Sprite thinking, frame 0 (32x32 - 16 colors)
sprite_thinking_0:
.byte 0, 0	; x- and y-offset
.word 2057+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite jf_son, frame 0 (16x32 - 16 colors)
sprite_jf_son_0:
.byte 0, 0	; x- and y-offset
.word 2073+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+14	;h, w, palette index

; Sprite 45degree, frame 0, part 0  (64x64 - 16 colors)
sprite_45degree_0_0:
.byte 0, 0	; x- and y-offset
.word 2081+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+14	;h, w, palette index

; Sprite 45degree, frame 0, part 1  (16x16 - 16 colors)
sprite_45degree_0_1:
.byte 41, 64	; x- and y-offset
.word 2145+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+3	;h, w, palette index

; Sprite 45deg_blinking, frame 0 (16x16 - 16 colors)
sprite_45deg_blinking_0:
.byte 0, 1	; x- and y-offset
.word 2149+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+14	;h, w, palette index

; Sprite 45deg_blinking, frame 1 (16x16 - 16 colors)
sprite_45deg_blinking_1:
.byte 0, 1	; x- and y-offset
.word 2153+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+14	;h, w, palette index

; Sprite 45deg_blinking, frame 2 (16x16 - 16 colors)
sprite_45deg_blinking_2:
.byte 0, 1	; x- and y-offset
.word 2157+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+14	;h, w, palette index

; Sprite 45deg_blinking, frame 3 (16x16 - 16 colors)
sprite_45deg_blinking_3:
.byte 0, 1	; x- and y-offset
.word 2161+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+14	;h, w, palette index

; Sprite mum, frame 0 (32x32 - 16 colors)
sprite_mum_0:
.byte 0, 0	; x- and y-offset
.word 2165+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+15	;h, w, palette index

; Sprite bigmum, frame 0, part 0  (64x64 - 16 colors)
sprite_bigmum_0_0:
.byte 0, 0	; x- and y-offset
.word 2181+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_64+15	;h, w, palette index

; Sprite head_crash, frame 0 (64x16 - 16 colors)
sprite_head_crash_0:
.byte 0, 2	; x- and y-offset
.word 2245+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_64+4	;h, w, palette index

; Sprite jf_fat, frame 0, part 0  (64x32 - 16 colors)
sprite_jf_fat_0_0:
.byte 1, 0	; x- and y-offset
.word 2261+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+6	;h, w, palette index

; Sprite jf_fat, frame 0, part 1  (16x32 - 16 colors)
sprite_jf_fat_0_1:
.byte 64, 13	; x- and y-offset
.word 2293+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+3	;h, w, palette index

; Sprite zack, frame 0 (64x32 - 16 colors)
sprite_zack_0:
.byte 0, 0	; x- and y-offset
.word 2301+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_64+12	;h, w, palette index

; Sprite toff_crash_slup, frame 0 (32x8 - 16 colors)
sprite_toff_crash_slup_0:
.byte 0, 1	; x- and y-offset
.word 2333+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite toff_crash_slup, frame 1 (32x8 - 16 colors)
sprite_toff_crash_slup_1:
.byte 0, 1	; x- and y-offset
.word 2337+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite toff_crash_slup, frame 2 (32x8 - 16 colors)
sprite_toff_crash_slup_2:
.byte 0, 1	; x- and y-offset
.word 2341+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+0	;h, w, palette index

; Sprite debris_hat, frame 0 (32x32 - 16 colors)
sprite_debris_hat_0:
.byte 0, 0	; x- and y-offset
.word 2345+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+12	;h, w, palette index

; Sprite debris_tail, frame 0 (32x16 - 16 colors)
sprite_debris_tail_0:
.byte 0, 1	; x- and y-offset
.word 2361+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+2	;h, w, palette index

; Sprite debris_prop, frame 0 (32x32 - 16 colors)
sprite_debris_prop_0:
.byte 1, 1	; x- and y-offset
.word 2369+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+4	;h, w, palette index

; Sprite debris_wing, frame 0, part 0  (32x16 - 16 colors)
sprite_debris_wing_0_0:
.byte 0, 3	; x- and y-offset
.word 2385+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+2	;h, w, palette index

; Sprite debris_wing, frame 0, part 1  (16x16 - 16 colors)
sprite_debris_wing_0_1:
.byte 32, 7	; x- and y-offset
.word 2393+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+2	;h, w, palette index

; Sprite propeller, frame 0 (8x64 - 16 colors)
sprite_propeller_0:
.byte 2, 0	; x- and y-offset
.word 2397+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_8+8	;h, w, palette index

; Sprite propeller, frame 1 (8x32 - 16 colors)
sprite_propeller_1:
.byte 2, 10	; x- and y-offset
.word 2405+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_8+8	;h, w, palette index

; Sprite propeller, frame 2 (8x8 - 16 colors)
sprite_propeller_2:
.byte 2, 21	; x- and y-offset
.word 2409+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+8	;h, w, palette index

; Sprite t1000, frame 0, part 0  (16x16 - 16 colors)
sprite_t1000_0_0:
.byte 18, 22	; x- and y-offset
.word 2410+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite t1000, frame 0, part 1  (32x32 - 256 colors)
sprite_t1000_0_1:
.byte 32, 0	; x- and y-offset
.word 2414+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite t1000, frame 0, part 2  (16x32 - 16 colors)
sprite_t1000_0_2:
.byte 64, 14	; x- and y-offset
.word 2446+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+5	;h, w, palette index

; Sprite t1000, frame 0, part 3  (32x32 - 256 colors)
sprite_t1000_0_3:
.byte 1, 32	; x- and y-offset
.word 2454+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite t1000, frame 0, part 4  (32x32 - 16 colors)
sprite_t1000_0_4:
.byte 32, 32	; x- and y-offset
.word 2486+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+6	;h, w, palette index

; Sprite t1000, frame 0, part 5  (16x16 - 16 colors)
sprite_t1000_0_5:
.byte 64, 32	; x- and y-offset
.word 2502+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+1	;h, w, palette index

; Sprite t1000, frame 0, part 6  (32x8 - 16 colors)
sprite_t1000_0_6:
.byte 0, 64	; x- and y-offset
.word 2506+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+6	;h, w, palette index

; Sprite bigplane, frame 0, part 0  (32x64 - 16 colors)
sprite_bigplane_0_0:
.byte 0, 23	; x- and y-offset
.word 2510+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+7	;h, w, palette index

; Sprite bigplane, frame 0, part 1  (32x64 - 256 colors)
sprite_bigplane_0_1:
.byte 32, 7	; x- and y-offset
.word 2542+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bigplane, frame 0, part 2  (32x64 - 256 colors)
sprite_bigplane_0_2:
.byte 64, 0	; x- and y-offset
.word 2606+VERA_sprite_colors_256	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_32+0	;h, w, palette index

; Sprite bigplane, frame 0, part 3  (8x64 - 16 colors)
sprite_bigplane_0_3:
.byte 96, 18	; x- and y-offset
.word 2670+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_64+VERA_sprite_width_8+2	;h, w, palette index

; Sprite bigplane, frame 0, part 4  (16x16 - 16 colors)
sprite_bigplane_0_4:
.byte 16, 64	; x- and y-offset
.word 2678+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+2	;h, w, palette index

; Sprite bigplane, frame 0, part 5  (32x16 - 16 colors)
sprite_bigplane_0_5:
.byte 32, 64	; x- and y-offset
.word 2682+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+2	;h, w, palette index

; Sprite bigplane, frame 0, part 6  (32x16 - 16 colors)
sprite_bigplane_0_6:
.byte 64, 64	; x- and y-offset
.word 2690+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_foreground	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_32+2	;h, w, palette index

