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
   .byte 0,0,0
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
ptr_check_return_to_basic:                ; 0 - check for exit
   .word check_return_to_basic, 0         
   no_commands_to_add

ptr_animate_fish:                         ; 1 - fish animation
   .word animate_sprite, jumping_fish     
   no_commands_to_add

ptr_animate_smoke:                        ; 2 - smoke animation
   .word animate_sprite, animated_smoke
   no_commands_to_add

events:
   .res 64,0

events_to_add:
   .res 16,0

events_to_remove:
   .res 16,0      

return_to_basic:
   .byte 0


.proc main
   
   ; restore state for multiple runs
   LoadB palfade_state, 0
   LoadB return_to_basic, 0
   LoadB events, 0
   LoadB events_to_add, 0
   LoadB events_to_remove, 0

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
   lda events                    ; worker count
   beq work_loop_empty
   ldx #1
fetch_next_worker:
   pha                           ; push the number of workers to call
   lda events,x                  ; get next function number
   asln 3                        ; multiply by 8
   tay
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
   ; save counter
   inx
   phx
jsr_to_patch:   
   jsr $DEAD                     ; dispatch the call
   plx
   pla
   dec
   bne fetch_next_worker

   lda return_to_basic
   beq repeat

work_loop_empty:

   ; cleanup
   clear_vsync_irq

   jsr switch_to_textmode   
   
   rts
.endproc

.proc check_return_to_basic
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q         
   bne carry_on
   ; q pressed - signal that we want to return to basic
   lda #1
   sta return_to_basic
carry_on:   
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

.proc fill_screen
   ; vera address0 set to 0, increment 1
   set_vera_address 0   
   LoadW R0, screen           ; screendata to R0 (source)        
   LoadW R1, VERA_data0       ; vera data #0 to R1 (destination)
   jsr memory_decompress
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
