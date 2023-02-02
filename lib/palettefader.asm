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
;
;
; runtime behavior:
;
; R1:       points to output palette
; R2L:      blue
; R2H:      green
; R3L:      16-f
; R3H:      red
; R4L:      target blue * factor
; R4H:      target green * factor
; R5L:      target red * factor
; R5H:      (16-f) << 4
;
.proc palettefader_step_fade
   ldy #5                  ; point to state
   lda (R15),y             ; get state
   iny   
   add (R15),y             ; change f (= lerp factor), carry is clear afterwards
   sta (R15),y             ; store the new factor
   bne not_zero
   ThisLoadW R15,R0,1,-    ; factor is zero, the fade is complete, make R0 point to the target palette
   jmp fade_complete
not_zero:
   cmp #16
   jeq output_destination_color

   tax                     ; x = f
   sta or_g_f+1            ; store f for green multiply
   sta re_read_factor+1    ; store for comparison
   nad 16                  ; a = 16-f
   sta R3L                 ; R3L = 16-f
   tay
   lda Asln4_table,y       ; a = 16-f << 4
   sta R5H                 ; R5H = 16-f << 4
   lda Asln4_table,x       ; a = f*16
   sta or_b_f+1            ; store f for blue multiply
   sta or_r_f+1            ; store f for red multiply

   ldy #3
   lda (R15),y             ; load target blue and green 
   and #$0f                ; a = blue
or_b_f:   
   ora #00                 ; a = f*16+blue, ready for table lookup
   tax                     
   lda Lerp416_table,x     ; multiply
   sta R4L                 ; R4L = target blue * factor

   lda (R15),y             ; load target blue and green 
   and #$f0                ; a = green
or_g_f:   
   ora #00                 ; a = f*16+g, ready for table lookup
   tax                     
   lda Lerp416_table,x     ; multiply
   sta R4H                 ; R4H = target green * factor

   iny
   lda (R15),y             ; a = red
or_r_f:   
   ora #00                 ; a = f*16+r, ready for table lookup
   tax                     
   lda Lerp416_table,x     ; multiply
   sta R5L                 ; R5L = target red * factor

   lda (R15)               ; get count
   tax                     ; x = count

   ldy #1
   ThisLoadW R15, R1       ; R1 now points to the palette   

   PushW R0                ; push R0 - it's used as moving output pointer while fading..

lerp_loop:
   lda (R1)                ; load palette value
   and #$0F                ; mask out the lower 4 bits, this is blue
   ora R5H                 ; a = 16-f || blue, ready for table lookup
   tay 
   lda Lerp416_table,y     ; multiply
   add R4L                 ; a = blended blue << 4
   and #$f0
   tay
   lda Rorn4_table,y       ; shifted down again, final blue
   sta orgb+1              ; store it for combining with 

   lda (R1)                ; load palette value   
   and #$F0                ; mask out the higher 4 bits, this is green
   ora R3L                 ; a = green || 16-f, ready for table lookup
   tay 
   lda Lerp416_table,y     ; multiply
   adc R4H                 ; a = blended green << 4
   and #$F0
orgb:   
   ora #00                 ; combine green with blue
   sta (R0)                ; store it

   IncW R0                 ; advance the output pointer
   IncW R1                 ; advance the palette pointer

   lda (R1)                ; load source red
   ora R5H                 ; a = 16-f || red, ready for table lookup
   tay 
   lda Lerp416_table,y     ; multiply
   adc R5L                 ; a = blended red << 4
   rorn 4                  ; shift down, to produce final red
   sta (R0)                ; store it

   IncW R0                 ; advance the output pointer
   IncW R1                 ; advance the palette pointer

   dex                     ; decrement
   bne lerp_loop

   PopW R0

re_read_factor:
   lda #00
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
output_destination_color:
   lda (R15)               ; get count
   tax   
   ldy #3
   lda (R15),y             ; read g+b
   sta loop+1              ; store it
   iny
   lda (R15),y             ; read r
   sta red+1               ; store it
   ldy #0
   PushB R0H
loop:
   lda #00                 ; get g+b
   sta (R0),y
   iny                     ; y can't overflow here..
red:
   lda #00                 ; get r
   sta (R0),y
   iny
   bne no_ov
   inc R0H
no_ov:   
   dex                     ; decrement
   cpx #255                ; did we overflow? then we are done..
   bne loop
   PopB R0H
   bra fade_complete
.endproc

.endif