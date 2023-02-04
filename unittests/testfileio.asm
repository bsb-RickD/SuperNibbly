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
Lstr "testload"

bad_filename:
Lstr "non_exist"

.byte "erik war da", CHR_NL, CHR_NL, CHR_NL

.proc load_test
   prints "file i/o test - load to banked ram", CHR_NL

   LoadW R0, bad_filename
   jsr file_open
   bcc bad_opened_ok
   prints "file open error on bad file - this was expected",CHR_NL
   jsr file_close
   bra open_real_file
bad_opened_ok:
   prints "bad file opened?"
status_and_exit:   
   prints " - something is wrong!",CHR_NL
   jmp exit
open_real_file:
   LoadW R0, filename
   jsr file_open
   bcc opened_ok
   prints "file open error on good file?"
   jmp status_and_exit
opened_ok:   
   lda #46              ; code for '.''
   jsr KRNL_CHROUT

   stz BANK
   lda #0
   lxy #$A000
   clc
   jsr KRNL_MACPTR   
   jsr KRNL_READST
   cmp #0
   beq opened_ok
   cmp #64
   beq worked
   prints "macptr not happy?"
   bra exit
worked:
   prints "macptr is happy :-) - all loaded"
exit:
   jsr file_close
   jsr KRNL_CLOSE_ALL
   rts
.endproc



