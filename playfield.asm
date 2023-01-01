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

.proc main

   jsr switch_to_tiled_mode

loop:
   wai
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q
   beq quit
   bra loop
   
quit:   
   jsr switch_to_textmode

   rts
.endproc

.proc switch_to_tiled_mode
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ; layer 0 = on, sprites = on, layer 1 = on
   ora #VERA_enable_layer_0 + VERA_enable_layer_1 + VERA_enable_sprites                   
   sta VERA_dc_video          ; set it
   LoadW VERA_dc_hscale,64    ; 2 pixel output     
   sta VERA_dc_vscale         ; 320 x 240   
   ; map 32x16, 16 colors, starting at 0, tiles start at 2k, 16x16
   LoadW VERA_L0_config, VERA_map_height_32 + VERA_map_width_32 + VERA_colors_16
   stz VERA_L0_mapbase   
   LoadB VERA_L0_tilebase, ((2048/VERA_tilebase_chunk) << 2) + VERA_tile_width_16 + VERA_tile_height_16

   ; map 32x16, 16 colors, starting at 0, tiles start at 2k, 16x16
   LoadW VERA_L1_config, VERA_map_height_32 + VERA_map_width_32 + VERA_colors_16
   LoadB VERA_L1_mapbase, (32*16*2 / VERA_mapbase_chunk)
   LoadB VERA_L1_tilebase, ((2048/VERA_tilebase_chunk) << 2) + VERA_tile_width_16 + VERA_tile_height_16

   rts
.endproc
