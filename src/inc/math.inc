.ifndef MATH_INC
MAH_INC = 1

Lerp416_table  = $400
Asln4_table    = $500
Rorn4_table    = $500

; 8 bit division, unsigned
;
; taken from http://6502org.wikidot.com/software-math-intdiv
;
; calculate: tq = tq/b, a = remainder of tq/b
; TQ, B: unsigned 8 bit numbers
;
.macro div88_ Tq, B
   .local @l1, @l2
      lda #0
      ldx #8
      asl Tq
@l1:
   rol
      cmp B
      bcc @l2
      sbc B
@l2:
   rol Tq
      dex
      bne @l1
.endmacro

; 16-bit division, 16-bit_result
;
; taken from https://codebase64.org/doku.php?id=base:16bit_division_16-bit_result
;
; divisor = 16 Bit number (in zero page)
; dividend = 16 Bit number (in zero page)
; remainder = 16 Bit number (in zero page)
;
; output:
; dividend = dividend/divisor (saves memory by reusing divident to store the result)
; remainder = remainder 
.macro div1616_ Divisor, Dividend, Remainder
   .local @div_loop, @skip
   stz Remainder     ;preset remainder to 0
   stz Remainder+1
   ldx #16           ;repeat for each bit: ...

@div_loop:
   asl Dividend      ;dividend lb & hb*2, msb -> Carry
   rol Dividend+1 
   rol Remainder     ;remainder lb & hb * 2 + msb from carry
   rol Remainder+1
   lda Remainder
   sec
   sbc Divisor       ;substract divisor to see if it fits in
   tay               ;lb result -> Y, for we may need it later
   lda Remainder+1
   sbc Divisor+1
   bcc @skip         ;if carry=0 then divisor didn't fit in yet

   sta Remainder+1      ;else save substraction result as new remainder,
   sty Remainder  
   inc Dividend      ;and INCrement result cause divisor fit in 1 times

@skip:
   dex
   bne @div_loop
.endmacro

; General 8bit * 8bit = 8bit multiply
; by White Flame 20030207
;
; taken from https://codebase64.org/doku.php?id=base:8bit_multiplication_8bit_product
;
; Multiplies "num1" by "num2" and returns result in .A
; Instead of using a bit counter, this routine early-exits when num2 reaches zero, thus saving iterations.
;
;
; Input variables:
;   num1 (multiplicand)
;   num2 (multiplier), should be small for speed
;   Signedness should not matter
;
; .X and .Y are preserved
; num1 and num2 get clobbered
.macro mul88_ Num1, Num2
   .local @do_add, @loop, @enter_loop, @end
   lda #$00
   beq @enter_loop
@do_add:
   clc
   adc Num1
@loop:
   asl Num1
@enter_loop: ;For an accumulating multiply (.A = .A + num1*num2), set up num1 and num2, then enter here
   lsr Num2
   bcs @do_add
   bne @loop
@end:
.endmacro

; 16*8 = 16 multiply
;
; Erik's code - might not be optimal
;
; result += num1 * num2
;
; result needs to be 16 bit            - if not initialized to zero, this becomes multiply add
; num1   also needs to be 16 bit
; num2   is 8 bit
.macro mul816_ Num1, Num2, Result
.local @next, @done, @shift
   ldx #8
   lda Num2
@next:   
   lsr   
   bcc @shift
   tay
   lda Result
   clc
   adc Num1
   sta Result
   lda Result+1
   adc Num1+1
   sta Result+1
   tya
@shift:  
   beq @done
   asl Num1
   rol Num1+1
   dex
   bne @next
@done:   
.endmacro

.endif