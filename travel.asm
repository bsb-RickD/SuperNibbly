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

.ifndef WORK_QUEUE_ASM
.include "lib/work_queue.asm"
.endif

.ifndef ARRAY_ASM
.include "lib/array.asm"
.endif

function_ptrs:
; bring in the function pointers for the work queue
.ifndef FUNCTION_PTRS_INC
.include "travel/travel_function_ptrs.inc"
.endif

.proc main
   ; restore state for multiple runs
   jsr switch_all_sprites_off

   ; init RNG
   jsr rand_seed_time

   jsr fill_screen
   jsr switch_to_320_240_tiled_mode

   ; establish vsync and copper list
   init_vsync_irq
   sei
   LoadW copper_list_start, green_copper_list
   LoadB copper_list_enabled, 1
   cli

   ; show sprites initially
   LoadW R15,mountain_bg_0+3
   ldx #8
show_sprites:
   phx
   jsr show_sprite
   plx
   dex
   beq all_sprites_shown
   AddVW 12,R15
   bra show_sprites
all_sprites_shown:   

   ; init work queue
   LoadW R15, work_queue
   lda #0
   sta (R15)

   lda #(TRAVEL_FPI+0)
add_fptrs:   
   pha
   jsr array_append
   pla
   inc
   cmp #(TRAVEL_FPI+8)
   bne add_fptrs

   ; main game loop - iterate the objects and update them
iterate_main_loop:   
   jsr wait_for_vsync

   jsr execute_work_queue

   jsr KRNL_GETIN                   ; read key
   cmp #KEY_Q         
   bne iterate_main_loop

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

   ; remember the decompress spot for the landscape sprites
   MoveW $9f20, decompress_landscape_sprites_vram_address

   ; decompress the green sprites right away
   LoadW R0, green_landscape  ; screendata to R0 (source)        
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

.include "travel/copper_lists.inc"
.include "travel/travel_common_sprites.inc"

.ifndef TRAVEL_WORKERS_ASM
.include "travel/travel_workers.asm"
.endif

travel_screen:
.incbin "assets/travel_data.bin"

TRAVEL_SCREEN_SIZE = *-travel_screen

; where to decompress the landscape (green, ice, desert..) to in VRAM
decompress_landscape_sprites_vram_address: .word 0

travel_pal:
.incbin "assets/travel_palette.bin"
TRAVEL_PALETTE_SIZE = *-travel_pal

green_landscape:
.incbin "assets/travel_green_sprites.bin"

volcano_landscape:
.incbin "assets/travel_volcano_sprites.bin"

ice_landscape:
.incbin "assets/travel_ice_sprites.bin"

desert_landscape:
.incbin "assets/travel_desert_sprites.bin"

.ifndef LZSA_ASM
.include "lib/lzsa.asm"
.endif
