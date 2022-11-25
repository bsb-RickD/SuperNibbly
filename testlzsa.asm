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


str_mem_test_different:
.byte "memory different",0


.proc main   
   print str_ut_welcome

   
   jsr test_mem_different
   jsr test_mem_equal
   jsr test_krnl_decompress
   jsr test_krnl_decompress_vram
   jsr test_lzsa_decompress   
   jsr test_lzsa_decompress_vram
   jsr test_vram_copy_krnl_d0
   jsr test_vram_copy_krnl_d1
   jsr test_vram_copy
   jsr test_vram_overlapping_copy
   jsr test_vram_overlapping_copy_d0d1   
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
test_vram_buffer:
   .res 10, 0

; fill vram with distinct pattern, copy back to ram, test equality
.proc test_vram_copy_krnl_d0
   prints "kernal memcopy vram(d0) -> ram"

   jsr test_helper_init_vram

   ; we'll read back from d0
   set_vera_address 0

   ; copy back
   mow #VERA_data0, R0         ; vera data #0 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)
   jsr KRNL_MEM_COPY

   ; compare
   compare_memory test_vram_buffer, test_vram_reference, 10
   ut_exp_equal

   rts
.endproc 

; fill vram with distinct pattern, copy back to ram, test equality
.proc test_vram_copy_krnl_d1
   prints "kernal memcopy vram(d1) -> ram"

   jsr test_helper_init_vram

   ; copy back
   mow #VERA_data1, R0         ; vera data #0 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)
   jsr KRNL_MEM_COPY

   switch_vera_to_dataport_0   ; CHROUT needs this to work   
   
   ; compare
   compare_memory test_vram_buffer, test_vram_reference, 10
   ut_exp_equal

   rts
.endproc 


; fill vram with distinct pattern, copy back to ram (manually), test equality
.proc test_vram_copy
   prints "manual memcopy vram -> ram"

   jsr test_helper_init_vram

   ; copy back
   ldx #10
   ldy #0
   mow #test_vram_buffer, R11
loop:   
   lda VERA_data1
   sta (R11),y
   iny
   dex
   bne loop
   mow #VERA_data1, R0         ; vera data #1 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)

   switch_vera_to_dataport_0   ; CHROUT needs this to work   

   ; compare
   compare_memory test_vram_buffer, test_vram_reference, 10
   ut_exp_equal

   rts
.endproc 


; copy overlapping from d1 -> d0
.proc test_vram_overlapping_copy
   prints "manual overl. copy vram d1 -> vram d0"

   jsr test_helper_init_vram

   ; VRAM is now $BB, $AA, $AA, $AA, $AA

   ; set vera address (to 1) on dataport 0 - we're gonna write here
   set_vera_address 1

   ; vera adddress 1 is set to 0 - so we copy the $BB from 0 to one
   ; and then we read the the just copied $BB from 1 and copy it to 2, etc.
   ; so after 9 copies, the first 10 bytes of VRAM should be $BB

   ldx #9
vram_loop:   
   lda VERA_data1
   sta VERA_data0
   dex
   bne vram_loop

   ; set vera data1 to 0
   stz VERA_addr_low

   ; copy back to RAM
   ldx #10
   ldy #0
   mow #test_vram_buffer, R11
loop:   
   lda VERA_data1
   sta (R11),y
   iny
   dex
   bne loop
   mow #VERA_data1, R0         ; vera data #1 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)

   ; compare
   compare_memory test_vram_buffer, buffer, 10
   ut_exp_equal

   rts
buffer:
.res 10, $BB
.endproc 

; copy overlapping from d0 -> d1
.proc test_vram_overlapping_copy_d0d1
   prints "manual overl. copy vram d0 -> vram d1"

   jsr test_helper_init_vram

   ; VRAM is now $BB, $AA, $AA, $AA, $AA

   ; set vera address (to 1) on dataport 1 - we're gonna write here
   set_vera_address 1, VERA_port_1, VERA_increment_1, 0

   ; set vera address (to 1) on dataport 1 - we're gonna write here
   set_vera_address 0, VERA_port_0, VERA_increment_1, 0

   ; vera adddress 1 is set to 0 - so we copy the $BB from 0 to one
   ; and then we read the the just copied $BB from 1 and copy it to 2, etc.
   ; so after 9 copies, the first 10 bytes of VRAM should be $BB

   ldx #9
vram_loop:   
   lda VERA_data0
   sta VERA_data1
   dex
   bne vram_loop

   ; set vera data1 to 0
   stz VERA_addr_low

   ; copy back to RAM
   ldx #10
   ldy #0
   mow #test_vram_buffer, R11
loop:   
   lda VERA_data1
   sta (R11),y
   iny
   dex
   bne loop
   mow #VERA_data1, R0         ; vera data #1 to R0 (source)
   mow #test_vram_buffer, R1   ; vram buffert to  R1 (destination)

   switch_vera_to_dataport_0   ; CHROUT needs this to work   

   ; compare
   compare_memory test_vram_buffer, buffer, 10
   ut_exp_equal

   rts
buffer:
.res 10, $BB
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
   ldx #10
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
   compare_memory test_vram_buffer, reference_buffer, 10
   ut_exp_equal

   rts
reference_buffer:
.res 10, $BB
.endproc 


; helper: fill vram with distinct pattern
.proc test_helper_init_vram
   ; set vera address (to 0) on dataport 0
   set_vera_address 0
   
   ; fill the memory
   fill_memory VERA_data0, 10, $AA
   stz VERA_addr_low
   lda #$BB
   sta VERA_data0

   ; set vera address (to 0) on dataport 1 - we're gonna read from here
   set_vera_address 0, VERA_port_1
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
   print msg
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

   ; get result 
   lda VERA_ctrl
   and #$FE
   sta VERA_ctrl
   ldy VERA_addr_low

   ; compare and print result
   cpy #LZSA_reference_len
   ut_exp_equal

   print msg
   prints " - comparison"

   ; fill the memory, just to initialize it
   fill_memory lzsa_output, LZSA_reference_len, $FF

   ; set vera address (to 0) on dataport 0 - we're gonna read here
   set_vera_address 0

   ; copy back to RAM
   ldx #LZSA_reference_len
   ldy #0
   mow #lzsa_output, R11
loop:   
   lda VERA_data0
   sta (R11),y
   iny
   dex
   bne loop

   switch_vera_to_dataport_0   ; CHROUT needs this to work   
   
   ; compare and print result
   compare_memory lzsa_output, lzsa_reference, LZSA_reference_len
   ut_exp_equal   

   rts
msg:
.byte "lzsa decompress vram",0
.endproc



.proc test_krnl_decompress_vram
   print msg
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
msg:
.byte "krnl decompress vram",0
.endproc


.proc test_mem_equal
   print msg
   prints "1"
   compare_memory memory_1, memory_1, MEMORY_len
   ut_exp_equal

   print msg
   prints "2"
   fill_memory memory_1, MEMORY_len, $AB
   fill_memory lzsa_output, MEMORY_len, $AB
   compare_memory memory_1, lzsa_output, MEMORY_len
   ut_exp_equal
   rts
msg:
.byte "mem same ",0
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