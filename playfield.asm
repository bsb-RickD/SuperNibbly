.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main
   
.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef VERA_ASM
.include "lib/vera.asm"
.endif

.ifndef VSYNC_ASM
.include "lib/vsync.asm"
.endif

.ifndef PALETTEFADER_ASM
.include "lib/palettefader.asm"
.endif

.proc main

loop:
   wai
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q
   beq quit
   bra loop
   
quit:   
   rts
.endproc