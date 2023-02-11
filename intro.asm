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

.ifndef UTIL_ASM
.include "lib/util.asm"
.endif

.ifndef SPRITES_ASM
.include "lib/sprites.asm"
.endif

.ifndef ARRAY_ASM
.include "lib/array.asm"
.endif

.ifndef RANDOM_ASM
.include "lib/random.asm"
.endif

.ifndef GENERIC_WORKERS_ASM
.include "lib/generic_workers.asm"
.endif

.ifndef WORK_QUEUE_ASM
.include "lib/work_queue.asm"
.endif

.ifndef FILEIO_ASM
.include "lib/fileio.asm"
.endif

.ifndef PRINT_ASM
.include "lib/print.asm"
.endif

sem_unpack:
   .byte 1

; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6
palfade_out:
   .byte 16
   .word c64_pal
   .byte $0a, $0
   .byte 0
   .byte 0

; palette fader structure
;
; .word palfade         ; offset 0 - ptr to palfade structure
; .word buffer          ; offset 2 - ptr to fade buffer
; .byte fadedirectrion  ; offset 4 - 0 to fade to target, 1 to fade from target color
; .word mapping         ; offset 5 - ptr to palette mapping
;
text_fade_out:
   .word palfade_out
   .word fadebuffer
   .byte 0
   .word standard_pal_mapping   

; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6
palfade_in:
   .byte INTRO_PALETTE_SIZE/2
   .word intro_pal
   .byte $0a, $0
   .byte 0
   .byte 0

; palette fader structure
;
; .word palfade         ; offset 0 - ptr to palfade structure
; .word buffer          ; offset 2 - ptr to fade buffer
; .byte fadedirectrion  ; offset 4 - 0 to fade to target, 1 to fade from target color
; .word mapping         ; offset 5 - ptr to palette mapping
;
intro_fade_in:
   .word palfade_in
   .word fadebuffer
   .byte 1
   .word intro_pal_mapping  

;
; .word vram_lm         ; offset 0 - low and med byte of address
; .byte vram_h          ; offset 1 - high byte of address
; .word source          ; offset 3 - ptr to compressed memory
; .byte bank            ; offset 5 - bank of the source memory
; .word store_address   ; offset 6 - ptr to memory to receive the address of the next byte in vram after decoding
;
intro_decompress_base_data:
   .word 0
   .byte 0                 ; decompress to vram 0
   .word intro_screen      ; source data
   .byte 0                 ; bank is irrelevant
   .word intro_decompress_additional_data 

intro_decompress_additional_data:
   .word 0                 ; address to be filled in..
   .byte 0                 ; ..by previous call
   .word $A000             ; source data
   .byte 1                 ; bank 1
   .word decompress_additional_data_end 

decompress_additional_data_end:
   .word 0
   .byte 0


function_ptrs:
.ifndef INTRO_FUNCTION_PTRS_INC
.include "intro/intro_function_ptrs.inc"
.endif

return_to_basic:
   .byte 0


; these are the buffers used by the wq_instance
main_exec_queue:
   .res 64,0
main_add_queue:
   .res 16,0
main_remove_queue:
   .res 16,0

wq_main_instance:
.word main_exec_queue
.word main_add_queue
.word main_remove_queue

; these are the buffers used by the wq_instance
vsync_exec_queue:
   .res 64,0
vsync_add_queue:
   .res 16,0
vsync_remove_queue:
   .res 16,0

wq_vsync_instance:
.word vsync_exec_queue
.word vsync_add_queue
.word vsync_remove_queue


; init state for multiple runs
.proc reset_intro_state
   jsr rand_seed_time            ; seed the random generator
   jsr init_lerp416_table        ; init the lerp table

   jsr switch_all_sprites_off
   
   stz palfade_state
   stz palfade_in+5
   stz palfade_out+5
   stz return_to_basic
   
   LoadW R15,wq_main_instance
   jsr init_work_queue

   LoadW R15,wq_vsync_instance
   jsr init_work_queue

   stz seq_jumping_fish+1
   LoadW jumping_fish, $0606
   LoadW jumping_fish+2, 17

   stz seq_wait_for_unpack+1

   stz par_init_fish_random+1
   
   jsr init_drop

   lda #1
   sta sem_unpack

   rts
.endproc

sprite_data_file:
Lstr "introsprites.bin"

.proc load_sprite_data
   LoadW R0, sprite_data_file
   jsr file_open
   ;bcs done

   LoadW R0, $A000
   LoadW R1, $FF01
   LoadW R2, 0
   jsr file_read
   ;bcs done

   jsr file_close
   ;bcs done

   set_vera_address 0

   LoadB BANK, 1
   LoadW R0, $A000
   LoadW R1, VERA_data0
   jsr memory_decompress 
   clc    

done:
   rts
.endproc   


.proc main      
   jsr reset_intro_state         ; init state for multiple runs

   /*
   jsr load_sprite_data          ; load the sprites
   bcs report_error

   LoadB BANK, 1
   LoadW R0, $A000
   LoadW R1H, $FF
   LoadW R2, 0
   jsr file_read
   */

   
   LoadW R15, wq_main_instance
   lda #intro_fp_index ptr_check_return_to_basic
   jsr add_to_work_queue         ; append check for exit to worker queue
   lda #intro_fp_index ptr_intro_decompress_base_data
   jsr add_to_work_queue         ; append decompression of intro base data to worker queue

   /*
   lda #intro_fp_index(ptr_unpack_intro)
   jsr add_to_work_queue         ; append unpacking of intro data to work queue
   */

   LoadW R15, wq_vsync_instance
   lda #intro_fp_index ptr_intro_startup 
   jsr add_to_work_queue         ; append intro startup to vsync queue

   ; install vsync work queue
   init_vsync_irq vsync_work_queue_handler   

   ; main game loop - iterate the objects and update them
iterate_main_loop:   
   jsr wait_for_vsync

   LoadW R15, wq_main_instance
   jsr execute_work_queue

   lda return_to_basic           ; shall we quit?
   beq iterate_main_loop         ; no, continue

   ; cleanup
   clear_vsync_irq
   jsr switch_to_textmode   
   
   rts
report_error:
   prints "file load error"   
   rts
.endproc

; this is the vsync routine, that executes the work queue
.proc vsync_work_queue_handler
   jsr push_all_registers
   jsr push_both_vera_addresses
   lda BANK                       ; also push ...
   pha                            ; ... the bank
   
   LoadW R15,wq_vsync_instance
   jsr execute_work_queue
   
done:
   pla                             ; pop the ...
   sta BANK                        ; ... bank
   jsr pop_both_vera_addresses
   jsr pop_all_registers
   
   jmp vsync_irq_exit
.endproc 

; after the palette fade out - enable our tiling mode
.proc all_blue_and_switch_to_tiled_mode   
   ldx intro_pal_mapping                  ; load the number of palette entries used
   lda #0
   MoveW palfade_out+3, R11
   jsr write_to_palette_const_color       ; set all used colors to fade target
   
   jsr switch_to_tiled_mode               ; switch to the intro screen - but it's still "invisible" because it's all a single color

   sec                                    ; one shot, mark as done
   rts   
.endproc

; worker procedure to check whether we shall quit or not
.proc check_return_to_basic
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q         
   bne carry_on
   ; q pressed - signal that we want to return to basic
   lda #1
   sta return_to_basic
   sec
   rts
carry_on:  
   clc 
   rts
.endproc   


palfade_state:
.byte 0




.proc switch_to_tiled_mode
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ; layer 0 = on, sprites = on, layer 1 = off
   ora #VERA_enable_layer_0 + VERA_enable_sprites                   
   sta VERA_dc_video          ; set it
   LoadW VERA_dc_hscale,64    ; 2 pixel output     
   sta VERA_dc_vscale         ; 320 x 240   
   ; map 64x32, 16 colors, starting at 0, tiles start at 4k, 8x8
   LoadW VERA_L0_config, VERA_map_height_32 + VERA_map_width_64 + VERA_colors_16
   stz VERA_L0_mapbase   
   LoadB VERA_L0_tilebase, ((4096/2048) << 2) + VERA_tile_width_8 + VERA_tile_height_8

   ; scroll a little bit up, so we can move when dropping the characters
   LoadB VERA_L0_vscroll_l, 8

   rts
.endproc

.proc waitkey
   wai
   jsr KRNL_GETIN    ; read key
   cmp #0
   beq waitkey
   rts
.endproc  

; animate a sprite "forever" - never indicate that this worker is done
;
; R15 points to sprite to animate
.proc loop_sprite
   jsr animate_sprite
   clc                  ; carry = clear - do forever
   rts 
.endproc

.ifndef LZSA_ASM
.include "lib/lzsa.asm"
.endif

.ifndef JUMPING_FISH_ASM
.include "intro/jumping_fish.asm"
.endif

.ifndef DROPPING_NIBBLY_ASM
.include "intro/dropping_nibbly.asm"
.endif

; animated sprite example class definition
;
; -------------------------------------- we start with the oversize sprite def ----------------------------
; .word 240,87         ; 0-3: position
; .addr sprite_smoke_0 ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 6              ; 8:   number of sprites in this oversize sprite
; -------------------------------------- additional anim parameters follow --------------------------------
; .byte 0              ; 9:   current anim-frame
; .byte 5              ; 10:  frames to wait before switching to next anim frame 
; .byte 5              ; 11:  current delay count


; this is the sprite class
animated_smoke:
.word 240,87         ; 0-3: position
.addr sprite_smoke_0 ; 4,5: sprite frame pointer
.word spritenum(126) ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 6              ; 8:   number of sprites in this oversize sprite
.byte 0              ; 9:   current anim-frame
.byte 5              ; 10:  frames to wait before switching to next anim frame 
.byte 5              ; 11:  current delay count
                     ; 12:  size of struct

intro_screen:
.incbin "assets/intro_data.bin"

INTRO_SCREEN_SIZE = *-intro_screen

intro_pal:
.incbin "assets/intro_palette.bin"
INTRO_PALETTE_SIZE = *-intro_pal

intro_pal_mapping:
.incbin "assets/intro_palette_mapping.bin"

standard_pal_mapping:
.byte 16,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

; this is where we fade into
fadebuffer:
.res INTRO_PALETTE_SIZE, 0
