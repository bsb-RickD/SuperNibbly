; Sprite mountain_bg, frame 0 (32x32 - 16 colors)
sprite_mountain_bg_0:
.byte 0, 0	; x- and y-offset
.word 1430+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+3	;h, w, palette index

; Sprite mountain_bg, frame 1 (32x32 - 16 colors)
sprite_mountain_bg_1:
.byte 0, 0	; x- and y-offset
.word 1446+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+3	;h, w, palette index

; Sprite mountain_bg, frame 2 (32x32 - 16 colors)
sprite_mountain_bg_2:
.byte 0, 0	; x- and y-offset
.word 1462+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+3	;h, w, palette index

; Sprite mountain_fg, frame 0 (32x8 - 16 colors)
sprite_mountain_fg_0:
.byte 0, 0	; x- and y-offset
.word 1478+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite mountain_fg, frame 1 (32x8 - 16 colors)
sprite_mountain_fg_1:
.byte 0, 0	; x- and y-offset
.word 1482+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite mountain_fg, frame 2 (32x8 - 16 colors)
sprite_mountain_fg_2:
.byte 0, 0	; x- and y-offset
.word 1486+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+1	;h, w, palette index

; Sprite trees, frame 0 (16x32 - 16 colors)
sprite_trees_0:
.byte 0, 0	; x- and y-offset
.word 1490+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+4	;h, w, palette index

; Sprite trees, frame 1 (16x32 - 16 colors)
sprite_trees_1:
.byte 0, 0	; x- and y-offset
.word 1498+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_16+4	;h, w, palette index

; Sprite houses, frame 0 (32x32 - 16 colors)
sprite_houses_0:
.byte 0, 0	; x- and y-offset
.word 1506+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

; Sprite houses, frame 1 (32x32 - 16 colors)
sprite_houses_1:
.byte 0, 0	; x- and y-offset
.word 1522+VERA_sprite_colors_16	; address/32 (+ color indicator) 
.word 0, 0	; x,y pos
.byte VERA_sprite_layer_background	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_32+VERA_sprite_width_32+0	;h, w, palette index

