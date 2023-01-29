.ifndef PALETTEFADER_ASM
PALETTEFADER_ASM = 1

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef MATH_ASM
.include "lib/math.asm"
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
   sta color_gb+1
   iny
   lda (R15),y
   sta color_r+1
   PushW R0
copy_colors:
color_gb:
   lda #00           ; offset 1 from copy_colors - this receives the color to copy
   sta (R0)      
   IncW R0
color_r:   
   lda #00           ; offset 6 from copy_colors - this receives the color to copy
   sta (R0)
   IncW R0
   dex
   cpx #255
   bne copy_colors
   PopW R0
   rts
.endproc

; R15:   this pointer
; R0:    points to memory to receive the interpolated palette 
;
; returns: 
;  c = 0: not done yet
;  c = 1: fade complete
;
; palette fader class layout
;
; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6 
.proc palettefader_step_fade
   ldy #5                  ; point to state
   lda (R15),y             ; get state
   iny   
   add (R15),y             ; change f (= lerp factor), carry is clear afterwards
   sta (R15),y

   sta R3L                 ; R3L = factor, remember factor for later
   ldy #0
   lda (R15),y             ; get count
   tax                     ; x = count

   iny 
   ThisLoadW R15, R1       ; R1 now points to the palette   
   lda (R15),y             ; a now holds blue and green
   rorn 4
   and #$F
   sta R2H                 ; R2H = green
   lda (R15),y             ; a now holds blue and green
   and #$F                 
   sta R2L                 ; R2L = blue
   iny
   lda (R15),y
   sta R3H                 ; R3H = red

   PushW R0                ; push R0 - it's used as moving output pointer while fading..

lerp_loop:
   phx

   lda (R1)                ; load palette value
   and #$F                 ; mask out the lower 4 bits, this is blue
   tax
   ldy R2L                 ; get blue of target color
   lda R3L                 ; load the factor
   jsr lerp416_lookup      ; a = lerped color

   sta (R0)                ; store it

   lda (R1)                ; load palette value (this is faster than pushing and pulling the previously loaded value)
   rorn 4
   and #$F                 ; shift and mask to get the higher 4 bits, this is green
   tax
   ldy R3H                 ; get green of target color
   lda R3L                 ; load the factor
   jsr lerp416_lookup      ; a = lerped color
   asln 4
   ora (R0)                ; combine green with blue
   sta (R0)                ; store it


   IncW R0                 ; advance the output pointer
   IncW R1                 ; advance the palette pointer

   lda (R1)                ; load source red
   tax
   lda R3H                 ; load target red
   tay
   lda R3L                 ; load the factor
   jsr lerp416_lookup      ; a = lerped color

   sta (R0)                ; store it

   IncW R0                 ; advance the output pointer
   IncW R1                 ; advance the palette pointer

   plx                     ; get count
   dex                     ; decrement
   cpx #255                ; did we overflow? then we are done..
   bne lerp_loop

   PopW R0

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