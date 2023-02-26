.ifndef UTIL_ASM
UTIL_ASM = 1

.segment "CODE"

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.macro save_return_address
   ; save return address   
   ply
   sty restore_return_address+4
   ply
   sty restore_return_address+1
.endmacro

;
; push registers R0-R15
;
.proc push_all_registers
   save_return_address

   ldy #31
loop:   
   lda R0L,y               ; push H
   pha
   lda R0L-1,y             ; push L
   pha
   dey
   dey
   bpl loop

   bra restore_return_address
.endproc


;
; pop registers R0-R15
;
.proc pop_all_registers
   save_return_address

   ldy #0
loop:   
   pla                     ; pop L
   sta R0L,y               
   pla                     ; pop H
   sta R0H,y   
   iny
   iny
   cpy #32
   bne loop
   bra restore_return_address
.endproc   


; a = bitmaks of registers to push
; lsb = register 8
; msb = register 15
;
; e.g. a = %10010100 will push register 10,12,15
;
.proc push_registers_8_to_15
   ldx #R8L
   bra push_registers_internal
.endproc

; a = bitmaks of registers to push
; lsb = register 0
; msb = register 7
;
; e.g. a = %10010011 will push register 0,1,4,7
;
.proc push_registers_0_to_7
   ldx #R0L   
   ; intentional fall through to push_registers_internal
.endproc

.proc push_registers_internal
   save_return_address

   ; update base register address
   stx update_here+1
   dex
   stx update_here+4

   ldy #15
loop:   
   rol 
   bcc dont_push
update_here:   
   ldx R0L,y               ; push H
   phx
   ldx R0L-1,y             ; push L
   phx
dont_push:
   dey
   dey
   bpl loop
.endproc   

; restore return address   
restore_return_address:
   ldy #00   
   phy
   ldy #00   
   phy
   rts

; a = bitmaks of registers to pop (which should have been pushed first with push_registers_8_to_15)
; lsb = register 8
; msb = register 15
;
; e.g. a = %10010100 will pop register 10,12,15
;
.proc pop_registers_8_to_15
   ldx #R8L
   bra pop_registers_internal
.endproc

; a = bitmaks of registers to pop (which should have been pushed first with push_registers_0_to_7)
; lsb = register 0
; msb = register 7
;
; e.g. a = %10010100 will pop register 10,12,15
;
.proc pop_registers_0_to_7
   ldx #R0L   
   ; intentional fall through to pop_registers_internal
.endproc


.proc pop_registers_internal
   save_return_address

   ; update base register address
   stx update_here+1
   inx
   stx update_here+4

   ldy #0
loop:   
   ror 
   bcc dont_pop
   plx                     ; pop L
update_here:   
   stx R0L,y               
   plx                     ; pop H
   stx R0H,y   
dont_pop:
   iny
   iny
   cpy #16
   bne loop
   bra restore_return_address
.endproc   

.endif