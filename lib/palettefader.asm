.ifndef PALETTEFADER_ASM
PALETTEFADER_ASM = 1

.ifndef COMMON_INC
.include "common.inc"
.endif

.ifndef MATH_ASM
.include "math.asm"
.endif

; palette fader class layout
;
; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6
;
; methods:
;     start_fade     carry specifies direction 0: fade towards target color, 1: fade from target color
;     step_fade      register specifies output buffer, carry 0: not done yet, carry 1: fade complete

; R15:   this pointer
; R0:    points to memory to receive the interpolated palette 
; c = 0: fade towards target color, 1: fade from target color
;
; After the call, R0 will point to the first palette fade
; this can either be a buffer filled with the target color or the original palette pointer
; (depending on the interpolation mode)
;
; returns: c will be 0 - so to indicate that step fade is not done yet
.proc palettefader_start_fade   
   bcs fade_from_target
   ; fade from source - move the palette pointer to R0
   jsr palettefader_output_source
   lda #1
   ldx #0
   bra set_state_and_f
fade_from_target:
   jsr palettefader_output_target
   lda #$FF
   ldx #16
   clc
set_state_and_f:   
   ldy #5                  ; point to state
   sta (R15),y             ; set state to increment / decrement
   iny
   txa
   sta (R15),y             ; set f to 0/16
   rts
.endproc

; R15:   this pointer
; copies the palette pointer to R0 - this is used when the source palette is reached
.proc palettefader_output_source
   ldy #1
   lda (R15),y
   sta R0L
   iny
   lda (R15),y
   sta R0H
   rts
.endproc

; R15:   this pointer
; copies the target color to R0 (as many times as num colors) - this is used when the target is reached
.proc palettefader_output_target
   ldy #0
   lda (R15),y
   tax            ; x = number of colors
   ldy #3
   lda (R15),y
   sta copy_colors+1
   iny
   lda (R15),y
   sta copy_colors+6
   ldy #0
copy_colors:
   lda #00           ; offset 1 from copy_colors - this receives the color to copy
   sta (R0),y
   iny         
   lda #00           ; offset 6 from copy_colors - this receives the color to copy
   sta (R0),y
   iny
   dex
   bne copy_colors
   rts
.endproc

; R15:   this pointer
; R0:    points to memory to receive the interpolated palette 
;
; returns: 
;  c = 0: not done yet
;  c = 1: fade complete
; 
.proc palettefader_step_fade
   ldy #5                  ; point to state
   lda (R15),y             ; get state
   iny   
   add (R15),y             ; change f, carry is clear afterwards
   sta (R15),y

   sta R3L                 ; R3L = factor, remember factor for later
   ldy #0
   lda (R15),y             ; get count
   asl
   pha                     ; a = index to last byte of the palette+1

init_regs:
   iny 
   lda (R15),y 
   tax
   stx R0H,y
   cpy #4
   bne init_regs

   ; R1 points to palette, R2 holds target color

   ply                     ; y = index to last byte of the palette+1

lerp_loop:
   dey
   lda (R1),y
   sty R3H                 ; remember palette index   
   tax
   lda R2H
   tay
   lda R3L                 ; load the factor
   jsr lerp416             ; a = lerped color

   ldy R3H
   sta (R0),y              ; store it
   dey                     ; move on

   lda (R1),y
   pha
   sty R3H                 ; remember palette index   
   and #$F
   tax
   lda R2L   
   and #$F
   tay
   lda R3L                 ; load the factor
   jsr lerp416             ; a = lerped color

   ldy R3H
   sta (R0),y              ; store it

   pla
   rorn 4
   and #$F
   tax
   lda R2L   
   rorn 4
   and #$F
   tay
   lda R3L                 ; load the factor
   jsr lerp416             ; a = lerped color
   asln 4
   ldy R3H
   ora (R0),y
   sta (R0),y              ; store it
   cpy #0
   bne lerp_loop

   lda R3L
   beq fade_complete
   cmp #16                 ; 0..15: C = 0, 16: C = 1
   beq fade_complete
   rts
fade_complete:
   ldy #5
   lda #0
   sta (R15),y             ; set state to zero
   sec                     ; set carry flag, to further indicate we're done!
   rts
.endproc

.endif