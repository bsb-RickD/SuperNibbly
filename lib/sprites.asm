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

; R15 this pointer to a sprite class
.proc switch_sprite_off
; the address of the sprite block is stored at offset 10
   stz VERA_ctrl
   ldy #10   
   lda (R15),y
   clc
   adc #6                           ; 6 is the offset to z-depth, etc.
   sta VERA_addr_low                ; lo byte
   iny
   lda (R15),y   
   sta VERA_addr_med                ; high byte
   lda #(1+ VERA_increment_1 + VERA_increment_addresses) ; this value is constant for all sprites
   sta VERA_addr_high   

   stz VERA_data0                   ; disable sprite
   rts
.endproc


; r1 points to "virtual screen position" of sprite
; r2 points to the address to hold the actual pos (= virtual pos + offset)
; a holds the offset to add
; y = 0 or 2, depending on x or y component
.proc add_sprite_offset_to_virtual_pos_compontent
   add (r1),y
   sta (r2),y
   iny   
   lda (r1),y
   adc #0
   sta (r2),y
   iny
   rts
.endproc   

; r0 = sprite-frame to update
; r1 = points to "virtual screen position" of sprite (x,y as 16 bit numbers)
.proc add_sprite_offset_to_virtual_pos
   ; set up R2 to point to position field in the sprite-frame structure
   lda R0L
   clc
   adc #4
   sta R2L
   lda R0H
   adc #0
   sta R2H

   ldy #1
   lda (r0),y
   tax               ; x = y offset
   dey 
   lda (r0),y        ; a = x offset

   jsr add_sprite_offset_to_virtual_pos_compontent
   txa
   jsr add_sprite_offset_to_virtual_pos_compontent 
   rts
.endproc

; R15 this pointer to a sprite class
; r0 = sprite-frame to update
;
.proc update_sprite_data
   ; the address of the sprite block is stored at offset 10
   stz VERA_ctrl
   ldy #10   
   lda (R15),y
   sta VERA_addr_low                ; lo byte
   iny
   lda (R15),y   
   sta VERA_addr_med                ; high byte
   lda #(1+ VERA_increment_1 + VERA_increment_addresses) ; this value is constant for all sprites
   sta VERA_addr_high
   
   ; now copy the actual data
   ldy #2
init_sprite:
   lda (r0),y
   sta VERA_data0
   iny
   cpy #10
   bne init_sprite
   rts
.endproc

; R15 this pointer to a sprite class
; r0 = sprite-frame to update
;
.proc update_sprite_data_and_position
   phx
   jsr point_r1_to_sprite_position
   jsr add_sprite_offset_to_virtual_pos
   jsr update_sprite_data
   plx
   rts
.endproc

; make R1 point to the position field of the sprite class 
; (effectively, R1 = R15+6)
;
; R15 this pointer to a sprite class
.proc point_r1_to_sprite_position
   lda R15L
   adc #6
   sta R1L
   lda R15H
   adc #0
   sta R1H
   rts
.endproc   

; R15 this pointer to a sprite class
; c is expected to be 0
.proc update_sprite_positions_for_single_sprite
   ; make R0 point to the sprite-frame-data (by copying the pointer at offset 4 to R0)
   ldy #4
   lda (R15),y
   sta R0L
   iny
   lda (R15),y
   sta R0H

   ; make R1 point to the position (to update the sprite-frame with)
   jsr point_r1_to_sprite_position

   ; update the positions
   bra add_sprite_offset_to_virtual_pos
.endproc


; R15 this pointer
;
.proc update_sprite_positions_for_multiple_sprites
   ldy #2
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

; cycle trough sprite animation frames
; call this every frame - will pause until the desired # of frames has passed
; will then switch to the next frame
;
; R15 this pointer
;
.proc animate_sprite
   ldy #0
   lda (R15),y       ; load frame delay
   tax               ; remember it
   iny
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
   ;dey               ; y = 1 again, pointing to delay count 
   txa               ; a = frame delay (was remembered in x)
   sta (R15),y       ; current delay count initialized again
   ldy #3            ; point to current frame
   lda (R15),y       ; get current frame
   inc               ; advance frame count
   dey               ; point to max frame count
   cmp (R15),y       
   bne not_looped_yet ;we can just increase the frame count (this also clears the carry flag)
   lda #0            ; we have looped, set to zero
   sec
not_looped_yet:
   iny
   sta (R15),y       ; stored new frame count
   rts
update_new_sprite_frame:
   ldy #3            ; point to current frame
   lda (R15),y       ; get current frame
multiply_frame_by_10:   
   asl
   sta add_offset+1  ; times 2
   asl
   asl
   clc
   adc add_offset+1  ; times 10
   sta add_offset+1  ; store as immediate value
   iny
   ; y is now 4, and we can calculate the sprite pointer
   lda (R15),y 
add_offset:   
   ; add offset of animation frame to sprite-frame base pointer
   adc #$aa          ; when we end up here, carry is clear for sure
   sta R0L    
   iny
   lda (R15),y 
   adc #0
   sta R0H           ; copy pointer over
   ;jsr update_sprite_data
   jsr update_sprite_data_and_position
   ldy #1
   bra decrase_frame_count
.endproc


.endif