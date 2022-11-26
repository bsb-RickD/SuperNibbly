; define a string with leading length
.define lstr(message) .byte .strlen(message), message

str_ut_welcome:
.byte (str_ut_passed-1-*),"=== unit test framework ===", CHR_NL, CHR_NL

str_ut_passed:
.byte (str_ut_failed-1-*), CHR_COLOR_GREEN, "passed", CHR_COLOR_WHITE, CHR_NL

str_ut_failed:
.byte (str_ut_failed_end-1-*), CHR_COLOR_RED, "failed", CHR_COLOR_WHITE, CHR_NL
str_ut_failed_end:

; print a string that was passed as parameter: prints "erik was here"
.macro prints str
   .local @msg
   .local @end
   mow #@msg, R11
   ldx #(@end-@msg)
   jsr print_x_length
   bra @end
@msg:
.byte str
@end:
.endmacro

; print a string at addr that has a leading length
.macro printl addr
   mow #addr, R11
   jsr print_length_leading
.endmacro

; print a string at addr that is zero terminated
.macro printz addr
   mow #addr, R11
   jsr print_zero_terminated
.endmacro

; switch vera back to data port 0 - CHROUT depends on that
.macro switch_vera_to_dataport_0
   stz VERA_ctrl
.endmacro

.macro fill_memory start, count, value
   mow #start, R0
   mow #count, R1
   lda #value
   jsr KRNL_MEM_FILL
.endmacro

.macro copy_memory source, dest, count
   mow #source, R0
   mow #dest, R1
   mow #count, R2
   jsr KRNL_MEM_COPY
.endmacro


.macro compare_memory mem1, mem2, len
   mow #mem1, R11
   mow #mem2, R12
   lxy #len
   jsr compare_memory_
.endmacro

; it is a pass Z is set
.macro ut_exp_equal
   jsr ut_pass_on_equal
.endmacro

; it is a pass if Z is clear
.macro ut_exp_neq
   jsr ut_pass_on_not_equal
.endmacro


; print unit test result - passed if Z is set
.proc ut_pass_on_equal
   php
   sec
   jsr KRNL_PLOT
   clc
   ldy #40
   jsr KRNL_PLOT
   plp
   bne failed
   printl str_ut_passed
   rts
failed:
   printl str_ut_failed
   rts
.endproc

; print unit test result - passed if Z is clear
.proc ut_pass_on_not_equal
   ; negate Z
   beq zero_set
   lda #0
   bra ut_pass_on_equal
zero_set:
   lda #1
   bra ut_pass_on_equal
.endproc


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

; R11 points to mem1
; R12 points to mem2
; x,y bytes to compare (low, high)
;
; Z set: memory equal
; Z clear: memory different (R11, R12 point to differing memory)
.proc compare_memory_
   lda (R11)
   cmp (R12)
   bne done
   IncW R11
   IncW R12
   dex
   bne compare_memory_
   dey
   bmi same
   ldx #$FF
   bra compare_memory_
same:
   lda #0   
done:
   rts
.endproc