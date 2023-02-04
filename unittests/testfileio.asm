.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef PRINT_ASM
.include "lib/print.asm"
.endif

.ifndef FILEIO_ASM
.include "lib/fileio.asm"
.endif

.proc main      
   jsr load_test
   rts
.endproc

.proc load_test
   prints "file i/o test - load to banked ram"
   newline
   rts
.endproc



