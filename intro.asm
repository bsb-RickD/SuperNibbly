.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

; to switch vsync irq and palette fading on or off
;USE_IRQ = 1 ; comment the line to turn off

.include "common.inc"
.include "vera.asm"
.ifdef USE_IRQ
.include "vsync.asm"
.endif
.include "palettefader.asm"
.include "print.asm"
   
; constants
FramesToWait      = 5

color:   .byte 0
inc_dec: .byte 1
bgcol:   .byte 0,0

c64_pal: .byte $00,$0, $ff,$f, $00,$8, $fe,$a, $4c,$c, $c5,$0, $0a,$0, $e7,$e,$85,$d,$40,$6,$77,$f,$33,$3,$77,$7,$f6,$a,$8f,$0,$bb,$b

filename_in: .byte   "in.bin",0
filename_out: .byte  "out.bin",0

; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)    offset 0
; pointer to palette       2 bytes                             offset 1
; target color             2 bytes                             offset 3
; state                    1 byte   (up/down/done)             offset 5
; current f                1 byte   (0..16)                    offset 6
palfade:
   .byte 16
   .word c64_pal
   .byte $0a, $0
   .byte 0
   .byte 0

; this is where we fade into
fadebuffer:
   .res 32, 0

.proc main
   /*
   LoadW R15, palfade
   clc
   jsr palettefader_start_fade

continue_fading:
   jsr set_palette_from_buffer

   LoadW R0, fadebuffer
   jsr palettefader_step_fade
   bcs fade_complete

   jsr waitkey

   stz VERA_control

   print_dec palfade+6

   bra continue_fading
fade_complete:
   jsr set_palette_from_buffer

   jsr waitkey
   */
   ; init state for multiple runs to be consistent
   stz color
   LoadB inc_dec, 1
   stz bgcol
   stz bgcol+1

.ifdef USE_IRQ
   init_vsync_irq
.endif

   jsr switch_to_tiled_mode
   jsr fill_screen

repeat:   
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q         
   beq done
   jsr KRNL_CHROUT   ; print to screen
.ifdef USE_IRQ   
   wai
   lda #FramesToWait
   cmp vsync_count
   bpl repeat
   stz vsync_count

   lda inc_dec
   cmp #1
   beq increase    
decrease:
   lda color
   dec
   sta color
   bne write2pal
   inc inc_dec
   bra write2pal
increase:
   lda color
   inc 
   sta color
   cmp #15
   bne write2pal
   dec inc_dec
write2pal:
   sal 4
   ora color
   sta bgcol
   sta bgcol+1
.endif   

   bra repeat   
done:

.ifdef USE_IRQ
   clear_vsync_irq
.endif   

   jsr switch_to_textmode   
   
   rts
.endproc

.proc waitkey
   wai
   jsr KRNL_GETIN    ; read key
   cmp #0
   beq waitkey
   rts
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
   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ora #$10                   ; layer 0 = on, sprites = off, layer 1 = off
   sta VERA_dc_video          ; set it
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   LoadW VERA_dc_hscale,64    ; 2 pixel output     
   sta VERA_dc_vscale         ; 320 x 240   
   ; map 64x32, 16 colors, starting at 0, tiles start at 4k, 8x8
   LoadW VERA_L0_config, VERA_map_height_32 + VERA_map_width_64 + VERA_colors_16
   stz VERA_L0_mapbase   
   LoadB VERA_L0_tilebase, ((4096/2048) << 2) + VERA_tile_width_8 + VERA_tile_height_8

   ; set palette
   LoadW R11, screen_pal
   ldx #(PALETTE_SIZE/2)-1
   lda #0
   sei
   jsr write_to_palette
   cli

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

.ifdef USE_IRQ
.endif

.include "lib/lzsa.asm"

screen:
.incbin "intro_bg.bin"

SCREEN_SIZE = *-screen

screen_pal:
.incbin "palette.bin"
PALETTE_SIZE = *-screen_pal

decompress:
.byte 255