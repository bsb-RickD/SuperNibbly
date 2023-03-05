.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef SPRITES_INC
.include "inc/sprites.inc"
.endif

.ifndef VSYNC_INC
.include "inc/vsync.inc"
.endif

function_ptrs:
; bring in the function pointers for the work queue
.ifndef FUNCTION_PTRS_INC
.include "travel/travel_function_ptrs.inc"
.endif

.import copper_list_start, copper_list_enabled
.import memory_decompress
.import write_to_palette
.import init_irq, vsync_irq, vsync_irq_exit, wait_for_vsync, reset_irq
.import init_work_queue, add_to_work_queue, execute_work_queue
.import array_append
.import switch_to_320_240_tiled_mode, switch_to_textmode
.import rand_seed_time
.import switch_all_sprites_off

.export function_ptrs

; these are the buffers used by the wq_instance
travel_exec_queue:
   .res 64,0
travel_add_queue:
   .res 16,0
travel_remove_queue:
   .res 16,0

wq_travel_instance:
.word travel_exec_queue
.word travel_add_queue
.word travel_remove_queue

.proc main
   ; restore state for multiple runs
   jsr switch_all_sprites_off

   ; init RNG
   jsr rand_seed_time

   jsr fill_screen

   lda #0
   jsr switch_to_landscape

   jsr switch_to_320_240_tiled_mode

   ; establish vsync, this also kicks off the copper list 
   init_vsync_irq

   ; init work queue
   LoadW R15,wq_travel_instance
   jsr init_work_queue

   
   ; populate work queue with the travel workers
   lda #(TRAVEL_FPI+0)
add_fptrs:   
   pha
   jsr add_to_work_queue
   pla
   inc
   cmp #(TRAVEL_FPI+23)
   bne add_fptrs

   ; main game loop - iterate the objects and update them
iterate_main_loop:   
   jsr wait_for_vsync

   LoadW R15,wq_travel_instance
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

   ; set the palette
   LoadW R11, travel_pal
   ldx #(TRAVEL_PALETTE_SIZE/2)-1
   lda #0
   sei
   jsr write_to_palette
   cli
   rts
.endproc

;
; a = landscape to switch to: 0 for green, 1 for volcano, 2 for ice, 3 for desert
;
.proc switch_to_landscape
   asl                              ; x 2
   sta R0                           ; stored
   asl                              ; x 4
   adc R0                           ; a = a x 6
   tay                              ; move it to y
   LoadW R15, landscape_pointers

   ; set vera decompression address
   stz VERA_ctrl
   MoveW decompress_landscape_sprites_vram_address, VERA_addr_low
   LoadB VERA_addr_high, VERA_increment_addresses | VERA_increment_1

   ; load compressed assets source address from the landscape pointers
   ThisLoadW R15,R0
   phy                              ; y already points to the pal index pointer, remember
   LoadW R1, VERA_data0             ; vera data #0 to R1 (destination)
   jsr memory_decompress            ; decompress the assets
   ply

   ; load pal indexes from the landspaces pointer
   ThisLoadW R15,R0                 ; R0 points to indexes to copy from
   phy                              ; y already points to the pal index pointer, remember
   LoadW R1,landscape_sprites+SD_h_w_pal    ; R1 points to the destination
   ldy #0
fix_pal_indexes:   
   lda (R0),y                       ; yeah, load the fixed pal index
   sta (R1)                         ; store it
   AddVW ::SD_size,R1               ; advance dest pointer
   iny                              ; advance source index
   cpy #NUM_SPRITE_INDEXES
   bne fix_pal_indexes
   ply

   ; load pal indexes from the landspaces pointer
   sei
   ThisLoadW R15,copper_list_start  ; copy copper list pointer over
   LoadB copper_list_enabled, 1
   cli

   rts
.endproc

.include "travel/copper_lists.inc"
.include "travel/travel_common_sprites.inc"

;.ifndef TRAVEL_WORKERS_ASM
;.include "travel/travel_workers.asm"
;.endif

travel_screen:
.incbin "assets/travel_data.bin"

TRAVEL_SCREEN_SIZE = *-travel_screen

; where to decompress the landscape (green, ice, desert..) to in VRAM
decompress_landscape_sprites_vram_address: .word 0

travel_pal:
.incbin "assets/travel_palette.bin"
TRAVEL_PALETTE_SIZE = *-travel_pal

green_sprite_indexes:
.include "travel/travel_green_pal_indexes.inc"
NUM_SPRITE_INDEXES = *-green_sprite_indexes

volcano_sprite_indexes:
.include "travel/travel_volcano_pal_indexes.inc"

ice_sprite_indexes:
.include "travel/travel_ice_pal_indexes.inc"

desert_sprite_indexes:
.include "travel/travel_desert_pal_indexes.inc"

green_landscape:
.incbin "assets/travel_green_sprites.bin"

volcano_landscape:
.incbin "assets/travel_volcano_sprites.bin"

ice_landscape:
.incbin "assets/travel_ice_sprites.bin"

desert_landscape:
.incbin "assets/travel_desert_sprites.bin"

; these pointers are used by the switch_to_landscape proc to do the work
landscape_pointers:
.word green_landscape, green_sprite_indexes, green_copper_list
.word volcano_landscape, volcano_sprite_indexes, volcano_copper_list
.word ice_landscape, ice_sprite_indexes, ice_copper_list
.word desert_landscape, desert_sprite_indexes, desert_copper_list