.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef MEMORY_INC
.include "inc/memory.inc"
.endif

.import memory_decompress
.import write_to_palette
.import switch_to_textmode
.import switch_all_sprites_off

tileset:
.byte 0

pills:
.byte 0

level:
.byte 0


.proc main

   jsr clear_map

   lda tileset
   jsr switch_gfx_set
   jsr show_level
   jsr switch_all_sprites_off

   jsr switch_to_tiled_mode

loop:
   wai
   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q
   beq quit
   cmp #KEY_T
   beq switch_gfx
   cmp #KEY_P
   beq switch_pills
   cmp #KEY_L
   beq switch_level
   bra loop
   
quit:   
   jsr switch_to_textmode

   rts

switch_gfx:
   lda tileset
   inc
   cmp #7
   blt switch_it
   lda #0   
switch_it:
   sta tileset
   jsr switch_gfx_set
   bra loop

switch_pills:
   lda pills
   clc
   adc #7
   cmp #36
   blt switch_it_p
   lda #0   
switch_it_p:
   sta pills
   jsr show_level
   bra loop

switch_level:
   lda level
   inc
   and #15
   sta level
   jsr show_level
   bra loop



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

   ; scroll the playfield a bit to the left
   LoadB VERA_L0_hscroll_l, 5
   sta VERA_L1_hscroll_l

   LoadB VERA_L0_vscroll_l, 0
   sta VERA_L0_hscroll_l
      
   rts
.endproc

; a = 0..6, the number of the set to switch to
; 
.proc switch_gfx_set
   asl
   tay
   LoadW R15, gfx_sets

   ; switch palette
   ThisLoadW R15, R11, -
   ldx #15
   lda #0
   sei
   jsr write_to_palette
   cli

   ; vera address0 set to 0, increment 1
   set_vera_address 2048
   AddW3 R11,#32,R0            ; R0 = source (32 bytes after the palette)
   LoadW R1, VERA_data0       ; vera data #0 to R1 (destination)
   jmp memory_decompress
.endproc

.proc clear_map
   set_vera_address 1, 0, VERA_increment_2
   fill_memory VERA_data0, 1024, 0

   set_vera_address 0, 0, VERA_increment_2
   fill_memory VERA_data0, 1024, 43
   rts
.endproc   

.proc show_level
   LoadW R15,levels              ; R15: points to the data itself 
   LoadW R12,levels-21           ; R12: 1 up, 1 left
   LoadW R13,levels-20           ; R13: 1 up
   LoadW R14,levels-1            ; R14: 1 left

   ; fix up high byte for the level count
   clc
   lda R15H
   adc level
   sta R15H

   lda R14H
   adc level
   sta R14H

   lda R13H
   adc level
   sta R13H

   lda R12H
   adc level
   sta R12H

   LoadW R11,VERA_data0

   set_vera_address 0,0,VERA_increment_2
   ; floors in layer 0
   ldy #0
   ldx #11                       ; 11 lines
loop_y:   
   phx
   ldx #20                       ; 20 columns
loop_x:
   stz combiner+1                ; initialize the value to store with 0

   lda (R15),y                   ; get byte from level map
   cmp #1
   beq combiner                  ; it's a wall, on the lower map, store as 0

   lda (R12),y
   cmp #1                  
   bne no_1
   AddVB 1,combiner+1            ; set the up left bit   
no_1:
   lda (R13),y
   cmp #1                  
   bne no_2
   AddVB 2,combiner+1            ; set the up bit   
no_2:
   lda (R14),y
   cmp #1                  
   bne combiner
   AddVB 4,combiner+1            ; set the left bit   
combiner:   
   lda #0                        ; load the combined value
   cmp #7
   blt store_it 
   lda #6                        ; cut it to 6, if necessary, 
store_it:
   clc
   adc pills   
   iny
   sta (R11)                     ; store it
   dex
   bne loop_x
   lda #5                        ; default border stone
   plx
   cpx #11                       ; check y-counter if we're still on first line
   bne store_right_border
   lda #44                       ; we're on the first line - select special corner stone
store_right_border:   
   sta (R11)
   AddVW 22, VERA_addr_low       ; line offset added to vera address
   dex
   bne loop_y

   ; add the segments for the last line
   lda #45
   ldx #20
last_line:   
   sta (R11)
   dex
   bne last_line
   lda #46
   sta (R11)

.endproc                         ; fall through to walls in layer 1

; walls in layer 1
.proc place_walls
   set_vera_address 1024,0,VERA_increment_2
   ldy #0
   ldx #11                       ; 11 lines
loop_y:   
   phx
   ldx #20                       ; 20 columns
loop_x:
   lda (R15),y                   ; get byte from level map
   iny
   cmp #1                        ; is it a wall?
   bne no_wall
   lda #42                       ; yes, get wall tile
   bra store_it
no_wall:
   lda #43   
store_it:   
   sta (R11)                     ; store it
   dex
   bne loop_x
   AddVW 24, VERA_addr_low       ; line offset added to vera address
   plx
   dex
   bne loop_y
   lda #43
   ldx #20
last_line:   
   sta (R11)
   dex
   bne last_line

   rts
.endproc

levels:
.incbin "assets/levels.bin"

gfx_set_1:
.incbin "assets/palette_gfx_set_1.bin"
.incbin "assets/wall_gfx_set_1.bin"

gfx_set_2:
.incbin "assets/palette_gfx_set_2.bin"
.incbin "assets/wall_gfx_set_2.bin"

gfx_set_3:
.incbin "assets/palette_gfx_set_3.bin"
.incbin "assets/wall_gfx_set_3.bin"

gfx_set_4:
.incbin "assets/palette_gfx_set_4.bin"
.incbin "assets/wall_gfx_set_4.bin"

gfx_set_5:
.incbin "assets/palette_gfx_set_5.bin"
.incbin "assets/wall_gfx_set_5.bin"

gfx_set_6:
.incbin "assets/palette_gfx_set_6.bin"
.incbin "assets/wall_gfx_set_6.bin"

gfx_set_7:
.incbin "assets/palette_gfx_set_7.bin"
.incbin "assets/wall_gfx_set_7.bin"

; pointers to palette + compressed wall data
;
; palette is always 32 bytes, so we know where the compressed data starts
gfx_sets:
.word gfx_set_1, gfx_set_2, gfx_set_3, gfx_set_4, gfx_set_5, gfx_set_6, gfx_set_7