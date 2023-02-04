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

filename:
Lstr "testLzsa.o"

.proc load_test
   prints "file i/o test - load to banked ram", CHR_NL

   LoadW R0, filename
   jsr file_open
/*   
   bcc opened_ok
   prints "file open error",CHR_NL
opened_ok:
   clc
*/   
   jsr file_close

   rts
.endproc



