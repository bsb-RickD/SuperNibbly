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

.ifndef VSYNC_ASM
.include "lib/vsync.asm"
.endif


volcano_copper_list:
.word 012, $88f   ; line, color
.word 016, $99f   ; line, color
.word 020, $aaf   ; line, color
.word 024, $bbf   ; line, color
.word 028, $ccf   ; line, color
.word 034, $bbf   ; line, color
.word 040, $aaf   ; line, color
.word 048, $99f   ; line, color
.word 052, $88f   ; line, color
.word 058, $77f   ; line, color
.word 064, $66f   ; line, color
.word 070, $55e   ; line, color
.word 076, $c91   ; line, color
.word 082, $ca1   ; line, color
.word 088, $cb2   ; line, color
.word 092, $888   ; line, color
.word 094, $aaa   ; line, color
.word 106, $888   ; line, color
.word 108, $cc3   ; line, color
.word 112, $dc4   ; line, color
.word 116, $ed5   ; line, color
.word 120, $fe6   ; line, color
.word $FFFF       ; marking the end

green_copper_list:
.word 012, $88f   ; line, color
.word 016, $99f   ; line, color
.word 020, $aaf   ; line, color
.word 024, $bbf   ; line, color
.word 028, $ccf   ; line, color
.word 034, $bbf   ; line, color
.word 040, $aaf   ; line, color
.word 048, $99f   ; line, color
.word 052, $88f   ; line, color
.word 058, $77f   ; line, color
.word 064, $66f   ; line, color
.word 070, $55e   ; line, color
.word 076, $373   ; line, color
.word 080, $383   ; line, color
.word 084, $393   ; line, color
.word 088, $3b3   ; line, color
.word 092, $888   ; line, color
.word 094, $aaa   ; line, color
.word 106, $888   ; line, color
.word 108, $4b3   ; line, color
.word 112, $4c4   ; line, color
.word 116, $5d5   ; line, color
.word 120, $6d5   ; line, color
.word 124, $f0f   ; line, color
.word $FFFF       ; marking the end

ice_copper_list:
.word 012, $88f   ; line, color
.word 016, $99f   ; line, color
.word 020, $aaf   ; line, color
.word 024, $bbf   ; line, color
.word 028, $ccf   ; line, color
.word 034, $bbf   ; line, color
.word 040, $aaf   ; line, color
.word 048, $99f   ; line, color
.word 052, $88f   ; line, color
.word 058, $77f   ; line, color
.word 064, $66f   ; line, color
.word 070, $55e   ; line, color
.word 076, $69e   ; line, color
.word 080, $7ae   ; line, color
.word 084, $8be   ; line, color
.word 088, $9ce   ; line, color
.word 092, $888   ; line, color
.word 094, $aaa   ; line, color
.word 106, $888   ; line, color
.word 108, $ace   ; line, color
.word 112, $bce   ; line, color
.word 116, $cde   ; line, color
.word 120, $dde   ; line, color
.word $FFFF       ; marking the end

desert_copper_list:
.word 012, $88f   ; line, color
.word 016, $99f   ; line, color
.word 020, $aaf   ; line, color
.word 024, $bbf   ; line, color
.word 028, $ccf   ; line, color
.word 034, $bbf   ; line, color
.word 040, $aaf   ; line, color
.word 048, $99f   ; line, color
.word 052, $88f   ; line, color
.word 058, $77f   ; line, color
.word 064, $66f   ; line, color
.word 070, $55e   ; line, color
.word 076, $ca2   ; line, color
.word 080, $db3   ; line, color
.word 084, $ec3   ; line, color
.word 088, $ed3   ; line, color
.word 092, $888   ; line, color
.word 094, $aaa   ; line, color
.word 106, $888   ; line, color
.word 108, $ee5   ; line, color
.word 112, $fe6   ; line, color
.word 116, $ff8   ; line, color
.word 120, $ffa   ; line, color
.word 124, $f0f   ; line, color
.word $FFFF    ; marking the end

water_copper_list:
.word 012, $88f   ; line, color
.word 016, $99f   ; line, color
.word 020, $aaf   ; line, color
.word 024, $bbf   ; line, color
.word 028, $ccf   ; line, color
.word 034, $bbf   ; line, color
.word 040, $aaf   ; line, color
.word 048, $99f   ; line, color
.word 052, $88f   ; line, color
.word 058, $77f   ; line, color
.word 064, $66f   ; line, color
.word 070, $55e   ; line, color
.word 076, $02b   ; line, color 
.word 080, $03c   ; line, color
.word 086, $14c   ; line, color
.word 092, $25d   ; line, color
.word 098, $36d   ; line, color
.word 104, $47e   ; line, color
.word 110, $58e   ; line, color
.word 116, $69f   ; line, color
.word 120, $7af   ; line, color
.word $FFFF    ; marking the end


.proc main
   ; restore state for multiple runs
   jsr switch_all_sprites_off

   ; init RNG
   jsr rand_seed_time

   jsr fill_screen
   jsr switch_to_320_240_tiled_mode

   init_vsync_irq

   sei
   LoadW copper_list_start, volcano_copper_list
   LoadB copper_list_enabled, 1
   cli

carry_on:
   wai
   jsr KRNL_GETIN                   ; read key
   cmp #KEY_Q         
   bne carry_on

   ; cleanup
   clear_vsync_irq
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
   sei
   jsr write_to_palette
   cli
   rts
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