.ifndef VERA_ASM
VERA_ASM = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef REGS_INC
.include "inc/mac.inc"
.endif

.ifndef REGS_INC
.include "inc/vera.inc"
.endif

; addr = 17 bit address, 
; optional: (default 0) dataport = 0/1
; optional: (default 1) increment = data increment 
; optional: (default 0) direction = 1 for decrement
.macro set_vera_address addr, dataport, increment, direction
.if .paramcount = 1
   set_vera_address_ addr, VERA_port_0, VERA_increment_1, VERA_increment_addresses
.elseif .paramcount = 2
   set_vera_address_ addr, dataport, VERA_increment_1, VERA_increment_addresses
.elseif .paramcount = 3
   set_vera_address_ addr, dataport, increment, VERA_increment_addresses
.elseif .paramcount = 4
   set_vera_address_ addr, dataport, increment, direction
.endif
.endmacro

; addr = 17 bit address, dataport = 0/1, increment = data increment, direction = 1 for decrement
.macro set_vera_address_ addr, dataport, increment, direction
.assert (addr) < $1FFFF, error, "when setting vera address, address must be smaller than $1FFFF"
.assert (dataport) = VERA_port_0 || (dataport) = VERA_port_1, error, "when setting vera address, dataport must be 0 or 1"
.assert ((increment) >= VERA_increment_0) && ((increment) <= VERA_increment_640), error, "when setting vera address, increment must be between 0 and 15"
.assert (direction) = VERA_increment_addresses || (direction) = VERA_decrement_addresses, error, "when setting vera address, direction must be 0 or 1"
   LoadB VERA_ctrl, dataport
   LoadB VERA_addr_low, ((addr) & $FF)
   LoadB VERA_addr_med, (((addr) >> 8) & $FF)
   LoadB VERA_addr_high, ((((addr) >> 16) & $1) | increment | direction)
.endmacro   

.proc push_current_vera_address
   ; save return address   
   plx
   ply

   ; now push the 4 address bytes
   lda VERA_ctrl
   pha
   lda VERA_addr_low
   pha
   lda VERA_addr_med
   pha
   lda VERA_addr_high
   pha

   ; restore return address   
   phy
   phx
   rts
.endproc

.proc push_both_vera_addresses
   ; save return address   
   plx
   ply

   ; first push the control byte
   lda VERA_ctrl
   pha

   ; switch to address 0
   and #$FE
   sta VERA_ctrl   

   ; push the 3 address bytes
   lda VERA_addr_low
   pha
   lda VERA_addr_med
   pha
   lda VERA_addr_high
   pha

   ; switch to address 1
   inc VERA_ctrl

   ; push the 3 address bytes
   lda VERA_addr_low
   pha
   lda VERA_addr_med
   pha
   lda VERA_addr_high
   pha

   ; restore return address   
   phy
   phx
   rts
.endproc

.proc pop_current_vera_address
   ; save current return address
   plx
   ply

   ; now pop the 4 address bytes
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_med
   pla
   sta VERA_addr_low
   pla
   sta VERA_ctrl

   ; restore return address, go back
   phy
   phx
   rts
.endproc

.proc pop_both_vera_addresses
   ; save current return address
   plx
   ply

   ; switch to address 1
   lda VERA_ctrl
   ora #$01
   sta VERA_ctrl

   ; now pop the 3 address bytes
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_med
   pla
   sta VERA_addr_low

   ; switch to address 0
   dec VERA_ctrl

   ; now pop the 3 address bytes
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_med
   pla
   sta VERA_addr_low

   ; finally restore control word
   pla
   sta VERA_ctrl

   ; restore return address   
   phy
   phx
   rts
.endproc


; a = palette index / color# to access
.proc set_vera_data_to_palette
   ldy #1
   sty VERA_ctrl                                ; use data #1 for palette
   asl                                          ; multiply index by 2
   sta VERA_addr_low                            ; store first 8 bit of address
   lda #(VRAM_palette >> 8) & $FF               ; second 8 bit of VRAM_Palette address
   adc #0                               
   sta VERA_addr_med                           ; store it
   lda #(VRAM_palette >> 16)+VERA_increment_1   ; last bit of VRAM_Palette address, increment 1
   sta VERA_addr_high

   rts
.endproc

; a = palette index / color# to write to
; x = # of colors-1 to write.. so to copy 1 color, set x = 0; to copy 256 colors set x = 255.
; R11 = pointer to color data to be copied to VRAM palette
.proc write_to_palette   
   jsr set_vera_data_to_palette
   ldy #0
for:   
   lda (R11),y
   sta VERA_data1
   iny 
   lda (R11),y
   sta VERA_data1
   iny
   bne next
   inc R11+1
next:
   dex
   bpl for
   rts
.endproc

; a = palette index / color# to write to
; x = # of colors-1 to write.. so to copy 1 color, set x = 0; to copy 256 colors set x = 255.
; R11 = color to write to palette x times
.proc write_to_palette_const_color
   jsr set_vera_data_to_palette
loop:   
   lda R11L
   sta VERA_data1
   lda R11H
   sta VERA_data1
   dex
   bpl loop
   rts
.endproc


.proc switch_to_320_240_tiled_mode
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


c64_pal: .byte $00,$0, $ff,$f, $00,$8, $fe,$a, $4c,$c, $c5,$0, $0a,$0, $e7,$e,$85,$d,$40,$6,$77,$f,$33,$3,$77,$7,$f6,$a,$8f,$0,$bb,$b

; go back to the textmode basic uses
;
;
.proc switch_to_textmode
   stz VERA_ctrl              ; dcsel and adrsel both to 0

   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ora #VERA_enable_layer_1   ; layer 1 = on, sprites = off, layer 0 = off
   sta VERA_dc_video          ; set it
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   LoadW VERA_dc_hscale, 128  ; 1 pixel output 
   sta VERA_dc_vscale         ; 640 x 480   
   ; map 128x64, 1bpp colors (textmode)
   LoadB VERA_L1_config, VERA_map_height_64 + VERA_map_width_128 + VERA_colors_2
   LoadB VERA_L1_mapbase, $D8
   LoadB VERA_L1_tilebase, $F8

   stz VERA_L0_hscroll_l
   stz VERA_L1_hscroll_l

   ; restore default palette   
   LoadW R11, c64_pal
   ldx #15
   lda #0
   sei
   jsr write_to_palette
   cli

   stz VERA_ctrl              ; make kernal happy

   rts
.endproc



.endif