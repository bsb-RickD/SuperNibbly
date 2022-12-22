.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.include "common.inc"
.include "vera.asm"
.include "vsync.asm"
.include "palettefader.asm"
.include "util.asm"
.include "sprites.asm"
.include "array.asm"
   
c64_pal: .byte $00,$0, $ff,$f, $00,$8, $fe,$a, $4c,$c, $c5,$0, $0a,$0, $e7,$e,$85,$d,$40,$6,$77,$f,$33,$3,$77,$7,$f6,$a,$8f,$0,$bb,$b

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

.macro commands_to_add p1, p2, p3, p4
.if .paramcount = 0
   .byte 0,0,0,0
.elseif .paramcount = 1
   .byte p1,0,0,0
.elseif .paramcount = 2
   .byte p1,p2,0,0
.elseif .paramcount = 3
   .byte p1,p2,p3,0
.elseif .paramcount = 4
   .byte p1,p2,p3,p4
.endif
.endmacro 

.define no_commands_to_add commands_to_add

function_ptrs:
   .word 0,0                              ; 0 - nullptr
   no_commands_to_add
ptr_check_return_to_basic:                ; 1 - check for exit
   .word check_return_to_basic, 0         
   no_commands_to_add

ptr_check_fill_screen:                    ; 2 - unpack screen data
   .word fill_screen, 0         
   commands_to_add 3                      ; after unpacking, wait for fadeout

ptr_check_fade_out_done:                  ; 3 - wait for fading out the palette
   .word fade_out_and_switch_to_tiled_mode, palfade_out         
   commands_to_add 4,5,6                  ; after fading out, fade back in and start the animations

ptr_fade_in:                              ; 4 - fade pal in
   .word fade_intro_in, palfade_in
   no_commands_to_add

ptr_animate_smoke:                        ; 5 - smoke animation
   .word animate_sprite, animated_smoke
   no_commands_to_add
ptr_animate_fish:                         ; 6 - fish animation
   .word animate_sprite, jumping_fish     
   no_commands_to_add


work_queue:
   .res 64,0

workers_to_add:
   .res 16,0

workers_to_remove:
   .res 16,0      

return_to_basic:
   .byte 0


.proc main
   
   ; restore state for multiple runs
   stz palfade_state
   stz palfade_in+5
   stz palfade_out+5
   stz return_to_basic
   stz work_queue
   stz workers_to_add
   stz workers_to_remove

   LoadW R15, work_queue
   lda #1
   jsr array_append              ; append check for exit to worker queue

   init_vsync_irq initial_fade_out   

   ; prepare gfx data, while we fade out the text screen
   jsr fill_screen               ; unpack data

wait_for_fadeout_to_complete:
   lda palfade_state
   cmp #2
   beq show_screen
   jsr wait_for_vsync
   bra wait_for_fadeout_to_complete

   ; at this point, the text screen has completely faded to the background color..

show_screen:
   ; set all used colors to fade target
   ldx #(PALETTE_SIZE/2)-1
   lda #0
   MoveW palfade_out+3, R11
   jsr write_to_palette_const_color

   ; switch to the intro screen - but it's still "invisible" because it's all a single color
   jsr switch_to_tiled_mode

   ; initialize pal fade
   LoadW R15, palfade_in
   LoadW R0, fadebuffer
   sec
   jsr palettefader_start_fade
   bra write_the_pal

fade_further:
   ; second time round, fade..
   LoadW R0, fadebuffer
   jsr palettefader_step_fade

   
write_the_pal:
   jsr wait_for_vsync
   MoveW R0, R11 
   ldx #(PALETTE_SIZE/2)-1
   lda #0
   jsr write_to_palette

   ldy #5
   lda (R15),y
   bne fade_further

   ; intro image has faded in, "main loop" starts here..
   
repeat:   
   jsr wait_for_vsync

   ; main game loop - iterate the objects and update them
   lda work_queue                ; worker count
   beq work_loop_empty
   ldx #1
fetch_next_worker:
   pha                           ; push the number of workers to call
   phx                           ; save worker index

   lda work_queue,x              ; get next function number
   asln 3                        ; multiply by 8
   tay                           ; y holds the offset to the function_ptrs table

   jsr call_worker               ; call the worker

   ; carry clear? - nothing to do, call worker again next frame
   bcc call_worker_next_frame    

   ; carry is set - this means remove current worker and add the new workers
   LoadW R15, workers_to_add
   ldx #4                        ; max of 4 pseudo pointers to add
append_workers:   
   iny                           ; advance to next worker to load
   lda function_ptrs,y           ; get the 1 byte pseudo pointer
   beq no_more_workers_2_append  ; null ptr found - stop evaluation workers to add
   jsr array_append              ; add it to the list of pointers to add 
   dex                           ; dec the counter of allowed pointers to add
   bne append_workers            ; try one more
no_more_workers_2_append:
   LoadW R15, workers_to_remove
   pla                           ; pull worker index - this is the one we want to remove
   pha                           ; push worker index back onto the stack
   jsr array_append              ; add the current
call_worker_next_frame:   
   plx                           ; restore worker index   
   inx                           ; advance to next index
   pla                           ; restore count
   dec
   bne fetch_next_worker         ; not at zero? get next worker

   jsr update_work_queue         ; update the workers list by removing old and adding new workers

   lda return_to_basic           ; shall we quit?
   beq repeat                    ; no, continue

work_loop_empty:

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

; call the worker 
; pass this pointer in R15
;
; y: index to function_ptrs table (worker index * 8)
;
; a,x get thrashed, y is pushed/pulled
;
; return: 
;  C = 0: worker not done, call again next frame
;  C = 1: worker has completed its work
;
.proc call_worker
   ; load address to jump to and write it to jsr below
   lda function_ptrs,y
   sta jsr_to_patch+1
   iny 
   lda function_ptrs,y
   sta jsr_to_patch+2
   ; load this pointer and copy it to R15
   iny
   lda function_ptrs,y
   sta R15L
   iny
   lda function_ptrs,y
   sta R15H      
   phy                           ; save index to worker data
jsr_to_patch:   
   jsr $CA11                     ; dispatch the call
   ply

   rts
.endproc

; take remove / add workers to queue
.proc update_work_queue
   LoadW R15, work_queue
   
   LoadW R14, workers_to_remove
   jsr array_remove_array

   LoadW R14, workers_to_add
   jsr array_append_array   

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

   rts
.endproc

.proc switch_to_textmode
   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ora #$20                   ; layer 1 = on, sprites = off, layer 1 = off
   sta VERA_dc_video          ; set it
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   LoadW VERA_dc_hscale, 128  ; 1 pixel output 
   sta VERA_dc_vscale         ; 640 x 480   
   ; map 128x64, 1bpp colors (textmode)
   LoadB VERA_L1_config, VERA_map_height_64 + VERA_map_width_128 + VERA_colors_2

   ; restore default palette   
   LoadW R11, c64_pal
   ldx #15
   lda #0
   sei
   jsr write_to_palette
   cli

   stz VERA_ctrl           ; dcsel and adrsel both to 0

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

.include "lib/lzsa.asm"

.include "sprites.inc"

; this is the sprite class
animated_smoke:
.byte 5              ; 0: frames to wait before switching to next anim frame 
.byte 5              ; 1: current delay count
.byte 6              ; 2: number of anim-frames
.byte 0              ; 3: current anim-frame
.addr sprite_smoke_0 ; 4,5: sprite frame pointer
.word 240,87         ; 6-9: position
.word spritenum(17)  ; 10,11: sprite# to use
                     ; 12: size of struct

jumping_fish:
.byte 6              ; 0:     frames to wait before switching to next anim frame 
.byte 6              ; 1:     current delay count
.byte 17             ; 2:     number of anim-frames
.byte 0              ; 3:     current anim-frame
.addr sprite_fish_0  ; 4,5:   sprite frame pointer
.word 40,100         ; 6-9:   position
.word spritenum(16)  ; 10,11: sprite# to use
                     ; 12: size of struct


screen:
.incbin "intro_data.bin"

SCREEN_SIZE = *-screen

screen_pal:
.incbin "palette.bin"
PALETTE_SIZE = *-screen_pal

; this is where we fade into
fadebuffer:
.res PALETTE_SIZE, 0
