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

; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6
palfade_in:
   .byte PALETTE_SIZE/2
   .word screen_pal
   .byte $0a, $0
   .byte 0
   .byte 0

function_ptrs:
.ifndef INTRO_FUNCTION_PTRS_INC
.include "intro/intro_function_ptrs.inc"
.endif

return_to_basic:
   .byte 0

; init state for multiple runs
.proc reset_intro_state
   stz palfade_state
   stz palfade_in+5
   stz palfade_out+5
   stz return_to_basic
   stz work_queue
   stz workers_to_add
   stz workers_to_remove
   LoadW jumping_fish, $0606
   LoadW jumping_fish+2, 17
   jsr switch_all_sprites_off
   jsr init_drop
   jsr rand_seed_time   
   rts
.endproc

.proc main   
   jsr reset_intro_state         ; init state for multiple runs
   
   LoadW R15, work_queue
   lda #(INTRO_FPI+1)
   jsr array_append              ; append check for exit to worker queue

   lda #(INTRO_FPI+2)
   jsr array_append              ; append unpacking of intro data to work queue

   init_vsync_irq initial_fade_out   

   ; main game loop - iterate the objects and update them
iterate_main_loop:   
   jsr wait_for_vsync

   jsr execute_work_queue

   lda return_to_basic           ; shall we quit?
   beq iterate_main_loop         ; no, continue

   ; cleanup
   clear_vsync_irq

   jsr switch_to_textmode   
   
   rts
.endproc


; check on the palette fade out  to be complete..
.proc fade_out_and_switch_to_tiled_mode
   ldy #5
   lda (R15),y          ; get fade state - 0 means fade is complete    
   beq complete
   clc                  ; indicate that worker is not done yet
   rts
complete:

   ; set all used colors to fade target
   ldx #(PALETTE_SIZE/2)-1
   lda #0
   MoveW palfade_out+3, R11
   jsr write_to_palette_const_color

   ; switch to the intro screen - but it's still "invisible" because it's all a single color
   jsr switch_to_tiled_mode

   sec                  ; fade complete - carry on with new workers
   rts   
.endproc

.proc fade_intro_in
   ; are we here the first time?
   ldy #5
   lda (R15),y
   bne fade_further

   ; initialize pal fade
   LoadW R0, fadebuffer
   sec
   jsr palettefader_start_fade
   bra write_the_pal

fade_further:
   ; second time round, fade..
   LoadW R0, fadebuffer
   jsr palettefader_step_fade

write_the_pal:
   MoveW R0, R11 
   ldx #(PALETTE_SIZE/2)-1
   lda #0
   jsr write_to_palette

   ldy #5
   lda (R15),y
   beq complete                  ; are we done?

   clc                           ; fade not done, carry on
   rts                  
complete:
   sec                           ; indicate that we're done
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

.proc initial_fade_out
   jsr push_current_vera_address
   lda #%00001111                   ; R0,R1,R2,R3
   jsr push_registers_0_to_7 
   lda #%10011000                   ; R11,R12,R15
   jsr push_registers_8_to_15 

   LoadW R15, palfade_out
   lda palfade_state
   bne init_done

   ; first time round, initialize everything..
   inc palfade_state
   clc
   LoadW R0, fadebuffer
   jsr palettefader_start_fade
   bra write_the_pal
init_done:

   ; second time round, fade..
   LoadW R0, fadebuffer
   jsr palettefader_step_fade
   bcc write_the_pal

   ; we should stop next frame
   inc palfade_state

write_the_pal:
   MoveW R0, R11 
   ldx #15
   lda #0
   sei
   jsr write_to_palette

   lda palfade_state
   cmp #2
   bne done

   ; our work here is done...
   clear_vsync_worker

done:
   lda #%10011000                   ; R11,R12,R15
   jsr pop_registers_8_to_15 
   lda #%00001111                   ; R0,R1,R2,R3
   jsr pop_registers_0_to_7 
   jsr pop_current_vera_address

   jmp vsync_irq_exit
.endproc 

.proc set_palette_from_buffer
   MoveW R0, R11 
   ldx #15
   lda #0
   sei
   jsr write_to_palette
   cli
   rts
.endproc   

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

; uncompress the screen data 
; plus some sprites
.proc fill_screen
   ; vera address0 set to 0, increment 1
   set_vera_address 0   
   LoadW R0, screen           ; screendata to R0 (source)        
   LoadW R1, VERA_data0       ; vera data #0 to R1 (destination)
   jsr memory_decompress
   sec                        ; set carry flag to indicate that the next worker task should start
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

screen:
.incbin "assets/intro_data.bin"

SCREEN_SIZE = *-screen

screen_pal:
.incbin "assets/intro_palette.bin"
PALETTE_SIZE = *-screen_pal

; this is where we fade into
fadebuffer:
.res PALETTE_SIZE, 0
