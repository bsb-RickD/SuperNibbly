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

.ifndef SPRITES_ASM
.include "lib/sprites.asm"
.endif

.ifndef RANDOM_ASM
.include "lib/random.asm"
.endif


.proc main
   ; restore state for multiple runs
   jsr switch_all_sprites_off

   ; init RNG
   jsr rand_seed_time

   jsr fill_screen
   jsr switch_to_320_240_tiled_mode


carry_on:
   wai
   jsr KRNL_GETIN                   ; read key
   cmp #KEY_Q         
   bne carry_on

   jsr switch_to_textmode   
   
   rts
.endproc


; uncompress the screen data 
; plus some sprites, plus palette
.proc fill_screen
   ; vera address0 set to 0, increment 1
   set_vera_address 0   
   LoadW R0, travel_screen    ; screendata to R0 (source)        
   LoadW R1, VERA_data0       ; vera data #0 to R1 (destination)
   jsr memory_decompress

   LoadW R11, travel_pal
   ldx #(TRAVEL_PALETTE_SIZE/2)-1
   lda #0
   jmp write_to_palette
.endproc

.ifndef LZSA_ASM
.include "lib/lzsa.asm"
.endif

travel_screen:
.incbin "assets/travel_data.bin"

TRAVEL_SCREEN_SIZE = *-travel_screen

travel_pal:
.incbin "assets/travel_palette.bin"
TRAVEL_PALETTE_SIZE = *-travel_pal