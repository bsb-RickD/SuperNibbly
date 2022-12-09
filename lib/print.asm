.ifndef print_zero_terminated

.include "common.inc"
.include "math.asm"

.macro print_push_state
   pha
   phx
   phy
   PushW R11
.endmacro

.macro print_pop_state
   PopW R11
   ply
   plx
   pla
.endmacro


; print a string that was passed as parameter: prints "erik was here"
.macro prints str
   .local @msg
   .local @end
   print_push_state
   LoadW R11, @msg
   ldx #(@end-@msg)
   jsr print_x_length
   bra @end
@msg:
.byte str
@end:
   print_pop_state
.endmacro

; print a string at addr that has a leading length
.macro printl addr
   print_push_state
   LoadW R11, addr
   jsr print_length_leading
   print_pop_state
.endmacro

; print a string at addr that is zero terminated
.macro printz addr
   print_push_state
   LoadW R11, addr
   jsr print_zero_terminated
   print_pop_state
.endmacro


; R11 points to string, zero terminated
.proc print_zero_terminated
   ldy #0
print_next_char:  
   lda (R11),y
   beq done
   jsr KRNL_CHROUT
   iny
   bne print_next_char
   inc R11H
   bra print_zero_terminated
done:
   rts
.endproc

; R11 points to string, which has the length as first byte
.proc print_length_leading 
   ldy #1
   lda (R11)
   tax
   bra print_x_length+2
.endproc   

; R11 points to string, x holds length
.proc print_x_length
   ldy #0
print_next_char:   
   lda (R11),y
   jsr KRNL_CHROUT
   iny
   dex
   bne print_next_char
   rts
.endproc

; lower nibble of a will be printed as hex
.proc print_hex_digit
   and #$0f
   adc #$30    ; $30 = "0"
   cmp #$3A    ; did we exceed 0..9?
   bcc print_char
   adc #$26    ; bring it to the "A".."F" range
print_char:
   jsr KRNL_CHROUT
   rts
.endproc

; print accumulator as hex
.proc print_hex
   pha
   rorn 4
   clc
   jsr print_hex_digit
   pla
   bra print_hex_digit     ; will return to caller
.endproc

.macro print_dec number
   .if .paramcount = 1
      ; param passed, so load a
      .if (.match (.left (1,{number}),#))
         ; immediate mode
         lda #(.right (.tcount ({number})-1, {number}))
      .else
         ; assume absolute oder zero page
         lda number
      .endif
   .endif
   jsr print_dec_
.endmacro

; print accumulator as decimal number
; r11, a, x clobbered
.proc print_dec_
   cmp #0
   bne not_zero
   clc
   bra print_hex_digit  ; special case - when 0 output single 0 and return (otherwise leading zeros are suppressed)
not_zero:   
   sta r11H
   lda #10
   sta r11L
   ldx #0
divide_loop:
   phx
   jsr div88            ; do divsion
   plx
   pha                  ; a is remainder, remember on stack
   inx                  ; inc number of digits to print
   lda r11H             ; are we done?
   bne divide_loop
print_loop:
   pla
   jsr print_hex_digit
   dex
   bne print_loop
   rts
.endproc


.endif