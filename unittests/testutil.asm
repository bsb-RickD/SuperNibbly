.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef UT_INC
.include "lib/ut.inc"
.endif

.ifndef PRINT_INC
.include "lib/print.inc"
.endif

.import ut_pass_on_not_equal, ut_pass_on_equal
.import push_all_registers, pop_all_registers, push_registers_0_to_7, push_registers_8_to_15, pop_registers_0_to_7, pop_registers_8_to_15
.import print_x_length, print_length_leading
.import str_ut_welcome


.proc main   
   printl str_ut_welcome
      
   jsr test_push_pop
   jsr test_push_pop_all

   rts
.endproc

push_pop_expected:
.byte 0,1,2,3,0,0,6,7,0,0,$A,$B,0,0,$E,$F,0,0,0,0,$14,$15,$16,$17,0,0,0,0,$1C,$1D,$1E,$1F

.proc test_push_pop
   prints "push_registers"

   ldx #32
   ldy #0

   ; distinct pattern
fill:
   tya
   sta R0,y
   iny
   dex
   bne fill

   ; push some
   lda #%10101011
   jsr push_registers_0_to_7
   lda #%11001100
   jsr push_registers_8_to_15

   ; clear all
   ldx #32
   ldy #0
   lda #0
clear:
   sta R0,y
   iny
   dex
   bne clear

   ; pop the pushed ones
   lda #%11001100
   jsr pop_registers_8_to_15   
   lda #%10101011
   jsr pop_registers_0_to_7

   ldy #0
compare:   
   lda R0,y
   cmp push_pop_expected,y
   bne different
   iny
   cpy #32
   bne compare
different:   
   ut_exp_equal
   rts
.endproc 

.proc test_push_pop_all
   prints "push_all_registers"
   LoadW R0,  $0102
   LoadW R1,  $0304
   LoadW R2,  $0506
   LoadW R3,  $0708
   LoadW R4,  $090A
   LoadW R5,  $0B0C
   LoadW R6,  $0D0E
   LoadW R7,  $0F10
   LoadW R8,  $1112
   LoadW R9,  $1314
   LoadW R10, $1516
   LoadW R11, $1718
   LoadW R12, $191A
   LoadW R13, $1B1C
   LoadW R14, $1D1E
   LoadW R15, $1F20

   jsr push_all_registers

   LoadW R0,  $0000
   LoadW R1,  $0000
   LoadW R2,  $0000
   LoadW R3,  $0000
   LoadW R4,  $0000
   LoadW R5,  $0000
   LoadW R6,  $0000
   LoadW R7,  $0000
   LoadW R8,  $0000
   LoadW R9,  $0000
   LoadW R10, $0000
   LoadW R11, $0000
   LoadW R12, $0000
   LoadW R13, $0000
   LoadW R14, $0000
   LoadW R15, $0000

   jsr pop_all_registers

   CmpWI R0,  $0102
   jne fail
   CmpWI R1,  $0304
   jne fail
   CmpWI R2,  $0506
   jne fail
   CmpWI R3,  $0708
   jne fail
   CmpWI R4,  $090A
   jne fail
   CmpWI R5,  $0B0C
   jne fail
   CmpWI R6,  $0D0E
   jne fail
   CmpWI R7,  $0F10
   jne fail
   CmpWI R8,  $1112
   jne fail
   CmpWI R9,  $1314
   jne fail
   CmpWI R10, $1516
   jne fail
   CmpWI R11, $1718
   jne fail
   CmpWI R12, $191A
   jne fail
   CmpWI R13, $1B1C
   jne fail
   CmpWI R14, $1D1E
   jne fail
   CmpWI R15, $1F20
   jne fail

   ut_pass
   rts
fail:
   ut_fail
   rts   
.endproc 

