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
   
c64_pal: .byte $00,$0, $ff,$f, $00,$8, $fe,$a, $4c,$c, $c5,$0, $0a,$0, $e7,$e,$85,$d,$40,$6,$77,$f,$33,$3,$77,$7,$f6,$a,$8f,$0,$bb,$b

filename_in: .byte   "in.bin",0
filename_out: .byte  "out.bin",0

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


; this is where we fade into
fadebuffer:
   .res 148, 0

.proc main
   
   ; restore state for multiple runs
   LoadB palfade_state, 0

   init_vsync_irq initial_fade_out   

   ; prepare gfx data, while we fade out the text screen
   jsr fill_screen               ; unpack data

   LoadW R15, animated_smoke
   jsr update_sprite_positions_for_multiple_sprites

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
   LoadW R15, animated_smoke
   jsr animate_sprite

   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q         
   beq done
   jsr KRNL_CHROUT   ; print to screen


   bra repeat   
done:
   clear_vsync_irq

   jsr switch_to_textmode   
   
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

; r1 points to "virtual screen position" of sprite
; r2 points to the address to hold the actual pos (= virtual pos + offset)
; a holds the offset to add
; y = 0 or 2, depending on x or y component
.proc add_sprite_offset_to_virtual_pos_compontent
   add (r1),y
   sta (r2),y
   iny   
   lda (r1),y
   adc #0
   sta (r2),y
   iny
   rts
.endproc   

; r0 = sprite to update
; r1 = points to "virtual screen position" of sprite (x,y as 16 bit numbers)
.proc add_sprite_offset_to_virtual_pos
   ; set up R2 to point to position field in the sprite structure
   MoveW R0,R2
   AddVW 4,R2

   ldy #1
   lda (r0),y
   tax               ; x = y offset
   dey 
   lda (r0),y        ; a = x offset

   jsr add_sprite_offset_to_virtual_pos_compontent
   txa
   jsr add_sprite_offset_to_virtual_pos_compontent 
   rts
.endproc

; r0 = sprite to update
;
.proc update_sprite_data
   set_vera_address VRAM_sprites
   ldy #2
init_sprite:
   lda (r0),y
   sta VERA_data0
   iny
   cpy #10
   bne init_sprite
   rts
.endproc

; R15 this pointer to a sprite class
; c is expected to be 0
.proc update_sprite_positions_for_single_sprite
   ; make R0 point to the sprite-frame-data (by copying the pointer at offset 4 to R0)
   ldy #4
   lda (R15),y
   sta R0L
   iny
   lda (R15),y
   sta R0H

   ; make R1 point to the position
   lda R15L
   adc #6
   sta R1L
   lda R15H
   adc #0
   sta R1H

   ; update the positions
   bra add_sprite_offset_to_virtual_pos
.endproc


; R15 this pointer
;
.proc update_sprite_positions_for_multiple_sprites
   ldy #2
   lda (R15),y    ; load number of sprites to update
   pha            ; push it
   clc
   jsr update_sprite_positions_for_single_sprite
   ; now r0 points to the first sprite and we can simply advance it by 10 to get to the next sprite
   plx
   dex
   beq all_updated
loop:   
   phx
   ; advance R0 by 10 bytes to get to next sprite
   lda R0L
   adc #10
   sta R0L
   bcc update_next
   inc R0H
   clc
update_next:
   ; update the offset
   jsr add_sprite_offset_to_virtual_pos
   plx
   dex
   bne loop
all_updated:   
   rts
.endproc

; cycle trough sprite animation frames
; call this every frame - will pause until the desired # of frames has passed
; will then switch to the next frame
;
; this routine assumes that all frames have the correct position already updated
; (see update_sprite_positions_for_multiple_sprites)
;
; R15 this pointer
;
.proc animate_sprite
   ldy #0
   lda (R15),y       ; load frame delay
   tax               ; remember it
   iny
   lda (R15),y       ; load delay count
   dec
   beq switch_to_next_frame 
   sta (R15),y       ; store decreased count
   rts
switch_to_next_frame:
   ; we have counted down the delay, initialize counter again, and animate
   txa
   sta (R15),y       ; reset counter to delay count
   iny  
   ; y is now 2, and we can advance animation frames
   lda (R15),y       ; load number of frames
   tax               ; remember it
   iny
   lda (R15),y       ; current frame
   inc
   sta (R15),y       ; store increased frame count
   dec 
   asl
   sta add_offset+1  ; times 2
   asl
   asl
   clc
   adc add_offset+1  ; times 10
   sta add_offset+1  ; store as immediate value
   iny
   ; y is now 4, and we can calculate the sprite pointer
   lda (R15),y 
add_offset:   
   adc #$aa          ; when we end up here, carry is clear for sure
   sta R0L    
   iny
   lda (R15),y 
   adc #0
   sta R0H           ; copy pointer over

   ldy #3
   txa               ; a = max frame count
   cmp (R15),y
   bne not_looped_yet
   lda #0
   sta (R15),y
not_looped_yet:   
   jmp update_sprite_data
.endproc


; R15 this pointer
.proc animate_sprite_plus_pos_update
   ; make R1 point to the position
   lda R15L
   add #6
   sta R1L
   lda R15H
   adc #0
   sta R1H

   ldy #0
   lda (R15),y       ; load number of frames
   tax               ; remember it number of frames
   iny
   lda (R15),y       ; current frame
   inc
   sta (R15),y
   dec 
   asl
   sta add_offset+1  ; times 2
   asl
   asl
   clc
   adc add_offset+1  ; times 10
   sta add_offset+1  ; store as immediate value
   iny
   ; y is now 4
   lda (R15),y 
add_offset:   
   adc #$aa          ; when we end up here, carry is clear for sure
   sta R0L    
   iny
   lda (R15),y 
   adc #0
   sta R0H           ; copy pointer over

   ldy #1
   txa               ; a = max frame count
   cmp (R15),y
   bne not_looped_yet
   lda #0
   sta (R15),y
not_looped_yet:   
   ;jmp update_sprite_pos
.endproc

.include "lib/lzsa.asm"

.include "sprites.inc"

; this is the sprite class
animated_smoke:
.byte 9              ; 0: frames to wait before switching to next anim frame 
.byte 7              ; 1: current delay count
.byte 5              ; 2: number of anim-frames
.byte 0              ; 3: current anim-frame
.addr sprite_smoke_0 ; 4: sprite frame pointer
.word 240,87         ; 6: position
                     ; 10: size of struct

screen:
.incbin "intro_data.bin"

SCREEN_SIZE = *-screen

screen_pal:
.incbin "palette.bin"
PALETTE_SIZE = *-screen_pal

decompress:
.byte 255