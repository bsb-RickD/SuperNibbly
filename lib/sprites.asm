.ifndef SPRITES_ASM
SPRITES_ASM = 1

.ifndef REGS_INC
.include "regs.inc"
.endif

.ifndef MAC_INC
.include "mac.inc"
.endif

.ifndef VERA_ASM
.include "vera.asm"
.endif

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
                       
; cycle trough sprite animation frames
; call this every frame - will pause until the desired # of frames has passed
; will then switch to the next frame
;
; R15 this pointer
;
.proc animate_sprite
   ldy #ASPR_frame_delay
   lda (R15),y       ; load frame delay
   tax               ; remember it
   iny               ; point to current fdc
   cmp (R15),y       ; compare frame delay to current delay count
   ; if they are equal, the anim frame was switched and we need to update to the new sprite
   beq update_new_sprite_frame 
decrase_frame_count:
   lda (R15),y       ; load delay count
   dec
   beq switch_to_next_frame 
   sta (R15),y       ; store decreased count
   clc
   rts
switch_to_next_frame:
   ; we have counted down the delay, initialize counter again, and switch to next frame index
   txa               ; a = frame delay (was remembered in x)
   sta (R15),y       ; current delay count initialized again
   ldy #ASPR_current_frame  ; point to current frame
   lda (R15),y       ; get current frame
   inc               ; advance frame count
   dey               ; point to max frame count (this is SPR_part_count)
   cmp (R15),y       
   bne not_looped_yet ;we can just increase the frame count (this also clears the carry flag)
   lda #0            ; we have looped, set to zero
   sec
not_looped_yet:
   iny
   sta (R15),y       ; stored new frame count
   rts
update_new_sprite_frame:
   ldy #ASPR_current_frame  ; point to current frame
   lda (R15),y       ; get current frame
multiply_frame_by_10:   
   asl
   sta add_offset+1  ; times 2
   asl
   asl
   clc
   adc add_offset+1  ; times 10
   sta add_offset+1  ; store as immediate value
   ldy #SPR_SD_ptr   ; get address of SD ptr   
   lda (R15),y 
add_offset:   
   ; add offset of animation frame to sprite-frame base pointer
   adc #$aa          ; when we end up here, carry is clear for sure
   sta R0L    
   iny
   lda (R15),y 
   adc #0
   sta R0H           ; copy pointer over
   jsr update_sprite_data_and_position
   ldy #ASPR_current_fdc
   bra decrase_frame_count
.endproc

; R15 this pointer to a sprite class (SPR)
;
; a holds the offset, e.g. 6 to switch off a sprite or 2 to set a new position or 0 to update all the attributes
; (this offset is expected to be 0..7, so this addition never can overflow into the next byte)
.proc set_vera_address_for_sprite
   stz VERA_ctrl
   ldy #SPR_attr_address            ; get the address of the sprite block from the SPR structure
   clc
   adc (R15),y                      ; add offset to the desired attribute
   sta VERA_addr_low                ; lo byte
   iny
   lda (R15),y   
   sta VERA_addr_med                ; high byte
   lda #(1+ VERA_increment_1 + VERA_increment_addresses) ; this value is constant for all sprites
   sta VERA_addr_high   
   rts
.endproc


; R15 this pointer to a sprite class (SPR)
.proc switch_sprite_off
   lda #6
   jsr set_vera_address_for_sprite  ; point vera to the address to switch the sprite off
   stz VERA_data0                   ; disable sprite

   ; need to add loop for multiple parts.. to switch them all off

   sec                              ; set c so we can use it as a one shot worker
   rts
.endproc


; r15 = points to Sprite (since the x position is at 0 this effectively points to SPR_x_position)
;
; r2 points to the address to hold the actual pos (= virtual pos + offset, meaning to a  SD_#_position
; a holds the offset to add
; y = 0 or 2, depending on x or y component
.proc add_sprite_offset_to_virtual_pos_compontent
   add (R15),y
   sta (R2),y
   iny   
   lda (R15),y
   adc #0
   sta (R2),y
   iny
   rts
.endproc   

; r15 = points to Sprite (since the x position is at 0 this effectively points to SPR_x_position)
;
; r0 = sprite-frame to update (pointing to an SD structure)
.proc add_sprite_offset_to_virtual_pos
   ; set up R2 to point to position field in the sprite-frame structure
   lda R0L
   add #SD_x_position
   sta R2L
   lda R0H
   adc #0
   sta R2H           ; R2 now points to SD_x_position

   ldy #SD_y_offset
   lda (R0),y
   tax               ; x = y offset
   dey 
   lda (R0),y        ; a = x offset

   jsr add_sprite_offset_to_virtual_pos_compontent
   txa
   jsr add_sprite_offset_to_virtual_pos_compontent 
   rts
.endproc

; R15 this pointer to a animated sprite class
; r0 = sprite-frame to update
;
.proc update_sprite_data   
   lda #0
   jsr set_vera_address_for_sprite  ; vera now points to the attribute block for this sprite
   
   ; now copy the actual data
   ldy #SD_VRAM_address
init_sprite:
   lda (r0),y
   sta VERA_data0
   iny
   cpy #SD_size
   bne init_sprite
   rts
.endproc

; R15 this pointer to a sprite class
; r0 = sprite-frame to update
;
.proc update_sprite_data_and_position
   phx
   ;jsr point_r1_to_sprite_position
   jsr add_sprite_offset_to_virtual_pos
   jsr update_sprite_data
   plx
   rts
.endproc

; R15 this pointer to a sprite class
; c is expected to be 0
.proc update_sprite_positions_for_single_sprite
   ; make R0 point to the sprite-frame-data (by copying the pointer at offset 4 to R0)
   ldy #SPR_SD_ptr
   lda (R15),y
   sta R0L
   iny
   lda (R15),y
   sta R0H

   ; update the positions
   bra add_sprite_offset_to_virtual_pos
.endproc


; R15 this pointer to SPR class
;
.proc update_sprite_positions_for_multiple_sprites
   ldy #SPR_part_count
   lda (R15),y    ; load number of sprites to update
   pha            ; push it
   clc
   jsr update_sprite_positions_for_single_sprite
   ; now r0 points to the first sprite and we can simply advance it by 10 to get to the next sprite
   ; and r1 
   plx
   dex
   beq all_updated
loop:   
   phx
   ; advance R0 by 10 bytes to get to next sprite
   lda R0L
   adc #10
   sta R0L
   bcc update_next
   inc R0H
   clc
update_next:
   ; update the offset
   jsr add_sprite_offset_to_virtual_pos
   plx
   dex
   bne loop
all_updated:   
   rts
.endproc

.endif