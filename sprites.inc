; Sprite smoke, frame 0
sprite_smoke_0:
.byte 4, 3	; x- and y-offset
.word 682	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite smoke, frame 1
sprite_smoke_1:
.byte 3, 3	; x- and y-offset
.word 684	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite smoke, frame 2
sprite_smoke_2:
.byte 3, 2	; x- and y-offset
.word 686	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite smoke, frame 3
sprite_smoke_3:
.byte 3, 2	; x- and y-offset
.word 688	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite smoke, frame 4
sprite_smoke_4:
.byte 4, 1	; x- and y-offset
.word 690	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite smoke, frame 5
sprite_smoke_5:
.byte 3, 1	; x- and y-offset
.word 692	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+0	;h, w, palette index

; Sprite fish, frame 0
sprite_fish_0:
.byte 8, 6	; x- and y-offset
.word 694	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 1
sprite_fish_1:
.byte 5, 4	; x- and y-offset
.word 695	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 2
sprite_fish_2:
.byte 4, 2	; x- and y-offset
.word 697	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 3
sprite_fish_3:
.byte 3, 1	; x- and y-offset
.word 699	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 4
sprite_fish_4:
.byte 4, 0	; x- and y-offset
.word 701	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 5
sprite_fish_5:
.byte 8, 0	; x- and y-offset
.word 705	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 6
sprite_fish_6:
.byte 9, 0	; x- and y-offset
.word 706	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 7
sprite_fish_7:
.byte 10, 0	; x- and y-offset
.word 707	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 8
sprite_fish_8:
.byte 12, 1	; x- and y-offset
.word 708	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 9
sprite_fish_9:
.byte 11, 3	; x- and y-offset
.word 709	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_8+4	;h, w, palette index

; Sprite fish, frame 10
sprite_fish_10:
.byte 9, 5	; x- and y-offset
.word 710	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 11
sprite_fish_11:
.byte 7, 6	; x- and y-offset
.word 712	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+4	;h, w, palette index

; Sprite fish, frame 12
sprite_fish_12:
.byte 5, 6	; x- and y-offset
.word 714	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite fish, frame 13
sprite_fish_13:
.byte 4, 5	; x- and y-offset
.word 718	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite fish, frame 14
sprite_fish_14:
.byte 4, 5	; x- and y-offset
.word 722	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite fish, frame 15
sprite_fish_15:
.byte 3, 5	; x- and y-offset
.word 726	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite fish, frame 16
sprite_fish_16:
.byte 2, 5	; x- and y-offset
.word 730	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_32+4	;h, w, palette index

; Sprite plane, frame 0
sprite_plane_0:
.byte 2, 4	; x- and y-offset
.word 734	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 1
sprite_plane_1:
.byte 2, 3	; x- and y-offset
.word 736	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 2
sprite_plane_2:
.byte 3, 2	; x- and y-offset
.word 738	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 3
sprite_plane_3:
.byte 5, 1	; x- and y-offset
.word 742	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 4
sprite_plane_4:
.byte 6, 0	; x- and y-offset
.word 744	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 5
sprite_plane_5:
.byte 6, 0	; x- and y-offset
.word 746	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 6
sprite_plane_6:
.byte 4, 1	; x- and y-offset
.word 748	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 7
sprite_plane_7:
.byte 3, 3	; x- and y-offset
.word 752	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 8
sprite_plane_8:
.byte 2, 3	; x- and y-offset
.word 754	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 9
sprite_plane_9:
.byte 3, 3	; x- and y-offset
.word 756	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 10
sprite_plane_10:
.byte 4, 3	; x- and y-offset
.word 758	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 11
sprite_plane_11:
.byte 5, 1	; x- and y-offset
.word 762	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 12
sprite_plane_12:
.byte 6, 0	; x- and y-offset
.word 764	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 13
sprite_plane_13:
.byte 5, 0	; x- and y-offset
.word 766	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_8+5	;h, w, palette index

; Sprite plane, frame 14
sprite_plane_14:
.byte 4, 1	; x- and y-offset
.word 768	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_16+VERA_sprite_width_16+5	;h, w, palette index

; Sprite plane, frame 15
sprite_plane_15:
.byte 3, 2	; x- and y-offset
.word 772	; address/32 (+ 16/256 bit as MSB)
.word 0, 0	; x,y pos
.byte 12	; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
.byte VERA_sprite_height_8+VERA_sprite_width_16+5	;h, w, palette index
