.ifndef SPRITES_INC
SPRITES_INC = 1

; use this macro to calculate sprite number -> address in VRAM for parameters
.define spritenum(n) (n*8)+$FC00

; sprite data example definition
; 
; Sprite smoke, frame 0 (8x16 - 16 colors)
; 
; .byte 4, 3                                          ; x- and y-offset
; .word 682+VERA_sprite_colors_16                     ; address/32 (+ color indicator) 
; .word 0, 0                                          ; x,y pos
; .byte 12                                            ; 4 bit Collision mask, 3 bit z-depth, VFlip HFlip
; .byte VERA_sprite_height_16+VERA_sprite_width_8+0   ; h, w, palette index

; offsets for the sprite data structure
SD_x_offset       = 0
SD_y_offset       = 1
;------------------------  everything below gets copied into VRAM
SD_VRAM_address   = 2  
SD_x_position     = 4
SD_y_position     = 6
SD_col_z_flips    = 8
SD_h_w_pal        = 9
SD_size           = 10

; oversize sprite example class definition
;
; .word 240,87         ; 0-3: position
; .addr sprite_smoke_0 ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 6              ; 8: number of sprites in this oversize sprite
;                      ; 9: size of struct

SPR_x_position    = 0   
SPR_y_position    = 2
SPR_SD_ptr        = 4   ; points to (first) SD struct
SPR_attr_address  = 6   ; points to (first) 8 bytes in VRAM where to copy SD struct to
SPR_part_count    = 8   ; how many parts does this oversize sprite / how many frames does this animation hold



; animated sprite example class definition
;
; -------------------------------------- we start with the oversize sprite def ----------------------------
; .word 240,87         ; 0-3: position
; .addr sprite_smoke_0 ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 6              ; 8:   number of sprites in this oversize sprite
; -------------------------------------- additional anim parameters follow --------------------------------
; .byte 0              ; 9:   current anim-frame
; .byte 5              ; 10:  frames to wait before switching to next anim frame 
; .byte 5              ; 11:  current delay count

ASPR_current_frame = 9
ASPR_frame_delay   = 10
ASPR_current_fdc   = 11
                       
.endif