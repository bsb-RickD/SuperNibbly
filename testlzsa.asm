.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "mac.inc"
.include "kernal_constants.asm"
.include "regs.inc"
.include "helpers.asm"
.include "ut.asm"
.include "vera.asm"
.include "lzsa.s"

.proc main   
   printl str_ut_welcome
   
   
   jsr test_mem_different
   jsr test_mem_equal
   jsr test_krnl_decompress
   jsr test_krnl_decompress_vram
   jsr test_lzsa_decompress   
   jsr test_lzsa_decompress_vram   
   jsr test_lzsa_decompress_vram_moving
   jsr test_vram_copy_krnl_d0
   jsr test_vram_copy_krnl_d1
   jsr test_vram_copy
   jsr test_vram_overlapping_copy_d0d1_manual_inc   
   

   rts
.endproc

.proc wait_key
   jsr KRNL_GETIN    ; read key
   cmp #0
   beq wait_key
   rts
.endproc


test_vram_reference:
   .byte $BB, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA
TEST_vram_reference_len = *-test_vram_reference;
test_vram_buffer:
   .res TEST_vram_reference_len, $FF

; fill vram with distinct pattern, copy back to ram, test equality
.proc test_vram_copy_krnl_d0
   prints "kernal memcopy vram(d0) -> ram"

   ; init the VRAM, and ram buffer
   jsr test_helper_init_vram
   
   ; copy back
   set_vera_address 0               ; we'll read back from d0
   copy_memory VERA_data0, test_vram_buffer, TEST_vram_reference_len

   ; compare
   compare_memory test_vram_buffer, test_vram_reference, TEST_vram_reference_len
   ut_exp_equal

   rts
.endproc 

; fill vram with distinct pattern, copy back to ram, test equality
.proc test_vram_copy_krnl_d1
   prints "kernal memcopy vram(d1) -> ram"

   jsr test_helper_init_vram

   ; copy back
   set_vera_address 0, VERA_port_1  ; data port 1 ready for reading
   copy_memory VERA_data1, test_vram_buffer, TEST_vram_reference_len

   switch_vera_to_dataport_0        ; CHROUT needs this to work   
   
   ; compare
   compare_memory test_vram_buffer, test_vram_reference, TEST_vram_reference_len
   ut_exp_equal

   rts
.endproc 


; fill vram with distinct pattern, copy back to ram (manually), test equality
.proc test_vram_copy
   prints "manual memcopy vram -> ram"

   jsr test_helper_init_vram

   ; set vera address (to 0) on dataport 0 - we're gonna read from here
   set_vera_address 0

   ; copy back
   ldx #TEST_vram_reference_len
   ldy #0
   mow #test_vram_buffer, R11
 loop:   
   lda VERA_data0
   sta (R11),y
   iny
   dex
   bne loop

   ; compare
   compare_memory test_vram_buffer, test_vram_reference, TEST_vram_reference_len
   ut_exp_equal

   rts
.endproc 

; copy overlapping from d0 -> d1
.proc test_vram_overlapping_copy_d0d1_manual_inc
   prints "address refreshing vram d0 -> vram d1"

   jsr test_helper_init_vram

   ; VRAM is now $BB, $AA, $AA, $AA, $AA

   ; set vera address (to 1) on dataport 1 - we're gonna write here
   set_vera_address 1, VERA_port_1, VERA_increment_1, 0

   ; set vera address (to 0) on dataport 0 - we're gonna read here, but no increment!
   set_vera_address 0, VERA_port_0, VERA_increment_1, 0

   ldx #9
 vram_loop:   
   lda VERA_data0
   sta VERA_data1
   lda VERA_addr_low
   sta VERA_addr_low
   dex
   bne vram_loop

   ; set vera address (to 0) on dataport 0 - we're gonna read here
   set_vera_address 0, VERA_port_0, VERA_increment_1, 0

   ; copy back to RAM
   ldx #TEST_vram_reference_len
   ldy #0
   mow #test_vram_buffer, R11
 loop:   
   lda VERA_data0
   sta (R11),y
   iny
   dex
   bne loop
   mow #VERA_data1, R0         ; vera data #1 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)

   switch_vera_to_dataport_0   ; CHROUT needs this to work   
   
   ; compare
   compare_memory test_vram_buffer, reference_buffer, TEST_vram_reference_len
   ut_exp_equal

   rts
reference_buffer:
.res 10, $BB
.endproc 


; helper: fill vram with distinct pattern $BB, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA, $AA
.proc test_helper_init_vram
   ; initialize the buffer used during test to a value not used in the test
   fill_memory test_vram_buffer, TEST_vram_reference_len, $FF

   ; set vera address (to 1) on dataport 0
   set_vera_address 1
   
   ; fill the memory
   fill_memory VERA_data0, TEST_vram_reference_len-1, $AA
   stz VERA_addr_low
   lda #$BB
   sta VERA_data0

   rts
.endproc


.proc test_krnl_decompress
   prints "krnl decompress"
   ; setup - init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF
   ; decompress
   mow #lzsa_input, R0
   mow #lzsa_output, R1
   jsr KRNL_MEM_DECOMPRESS
   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal
   rts
.endproc

.proc test_lzsa_decompress
   prints "lzsa decompress"
   ; setup - init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF
   ; decompress
   mow #lzsa_input, R0
   mow #lzsa_output, R1
   jsr memory_decompress
   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal
   rts
.endproc

.proc test_lzsa_decompress_vram
   printl msg
   prints " - #output bytes"

   ; set vera address (to 0)
   set_vera_address 0

   ; fill the memory
   fill_memory VERA_data0, LZSA_reference_len, $FF

   ; reset vera address (to 0)
   stz VERA_addr_low

   ; decompress
   mow #lzsa_input, R0
   mow #VERA_data0, R1
   jsr memory_decompress

   switch_vera_to_dataport_0        ; output address is on port 0

   ; get result - how many bytes have been written?
   ldy VERA_addr_low

   ; compare and print result
   cpy #LZSA_reference_len
   ut_exp_equal

   printl msg
   prints " - comparison"

   ; fill the memory, just to initialize it
   fill_memory lzsa_output, LZSA_reference_len, $FF

   ; copy back
   set_vera_address 0               ; we'll read back from d0
   copy_memory VERA_data0, lzsa_output, LZSA_reference_len

   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal   

   rts
msg: lstr "lzsa decompress vram"
.endproc


lzsam_count:
.byte $01

lzsam_addr:
.dword $FFFF-31

; set vera address (to lzsam_addr) for data port 0
.proc set_vaddr
   stz VERA_ctrl
   mob lzsam_addr, VERA_addr_low
   mob lzsam_addr+1, VERA_addr_high
   lda lzsam_addr+2
   and #1
   ora #VERA_increment_1
   sta VERA_addr_bank
   rts
.endproc

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

.proc print_hex
   pha
   ror
   ror
   ror
   ror
   clc
   jsr print_hex_digit
   pla
   bra print_hex_digit
.endproc


.proc test_lzsa_decompress_vram_moving
   lda #01
   sta lzsam_count
   ldx #$09
next_round:   
   phx

   printl msg
   lda lzsam_count
   ;jsr KRNL_CHROUT
   jsr print_hex
   
   ; set vera address (to lzsam_addr) for data port 0
   jsr set_vaddr

   ; fill the memory
   fill_memory VERA_data0, LZSA_reference_len, $FF

   ; reset vera address (to lzsam_addr) for data port 0
   jsr set_vaddr

   ; decompress
   mow #lzsa_input, R0
   mow #VERA_data0, R1
   jsr memory_decompress

   ; fill the memory, just to initialize it
   fill_memory lzsa_output, LZSA_reference_len, $FF

   ; copy back
   jsr set_vaddr     ; again, set address on data port0 - we'll copy from here
   copy_memory VERA_data0, lzsa_output, LZSA_reference_len

   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal

   ; increase address by 7
   clc
   lda lzsam_addr
   adc #7
   sta lzsam_addr
   lda lzsam_addr+1
   adc #0
   sta lzsam_addr+1
   lda lzsam_addr+2
   adc #0
   sta lzsam_addr+2

   ; increase count (as bcd)
   sed
   lda lzsam_count
   clc
   adc #1
   sta lzsam_count
   cld

   ; pull x and loop
   plx
   dex
   beq done
   jmp next_round
done:   

   rts
msg: lstr "lzsa decompress vram moving dest "
.endproc


.proc test_krnl_decompress_vram
   printl msg
   prints " - #output bytes"
   ; setup - init memory to ff
   fill_memory lzsa_output, LZSA_reference_len, $FF

   ; set vera address (to 0)
   set_vera_address 0
   
   ; decompress
   mow #lzsa_input, R0
   mow #VERA_data0, R1
   jsr KRNL_MEM_DECOMPRESS

   ; check number of bytes output
   lda VERA_addr_low
   cmp #LZSA_reference_len
   ut_exp_equal

   /*
   ; compare and print result
   print msg
   prints " - memcmp"
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal
   */
   rts
msg: lstr "krnl decompress vram"
.endproc


.proc test_mem_equal
   printl msg
   prints "1"
   compare_memory memory_1, memory_1, MEMORY_len
   ut_exp_equal

   printl msg
   prints "2"
   fill_memory memory_1, MEMORY_len, $AB
   fill_memory lzsa_output, MEMORY_len, $AB
   compare_memory memory_1, lzsa_output, MEMORY_len
   ut_exp_equal
   rts
msg: lstr "mem same "
.endproc

.proc test_mem_different
   prints "mem different"
   compare_memory memory_1, memory_2, lzsa_output
   ut_exp_neq  ; we expect compary to report difference!
   rts
msg:

.endproc

memory_1: .byte 1,2,3,4,5,6,7,8,9,10
MEMORY_len = *-memory_1
memory_2: .byte 1,2,3,4,7,6,7,8,9,10

lzsa_reference:
.incbin "test.bin"

LZSA_reference_len = *-lzsa_reference

lzsa_input:
.incbin "test.cpr"

LZSA_input_len = *-lzsa_input

lzsa_output:
.res LZSA_reference_len, 0