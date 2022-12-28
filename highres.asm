.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

.ifndef COMMON_INC
.include "common.inc"
.endif

.ifndef VERA_ASM
.include "vera.asm"
.endif

.ifndef VSYNC_ASM
.include "vsync.asm"
.endif



old_irq:
.word 0

.proc main
   sei
   LoadB VERA_ien,2
   LoadW R0, hsync_irq
   jsr init_irq

   jsr switch_to_highres_bitmap_mode   


carry_on:
   bra carry_on
   ;jsr wait_for_vsync

   jsr KRNL_GETIN    ; read key
   cmp #KEY_Q         
   bne carry_on

   
   ; cleanup
   jsr reset_irq
   jsr switch_to_textmode
   rts
.endproc

nextline:
.word 0


; the actual vsync routine
;
; increases the vsync count
;
.proc hsync_irq
   sei                                 ; disable interrupts
   lda VERA_isr
   and #2                              ; check vsync bit
   jeq irq_exit                        ; bits not set - no vsync or hsync

   sta VERA_isr                        ; acknowledge IRQ

   set_vera_address 0
   lda VERA_irqline_low

   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0

   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0

   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   
   
   inc VERA_irqline_low

irq_exit:
   ply
   plx
   pla            ; restore regs

   rti            ; kansas goes bye-bye
.endproc   


.proc switch_to_highres_bitmap_mode
   stz VERA_ctrl              ; dcsel and adrsel both to 0
   lda VERA_dc_video
   and #7                     ; keep video and chroma mode
   ; layer 0 = on, sprites = on, layer 1 = off
   ora #VERA_enable_layer_0 + VERA_enable_sprites                   
   sta VERA_dc_video          ; set it
   LoadW VERA_dc_hscale,128   ; 1 pixel output     
   stz VERA_dc_vscale         ; 640 x 480, first line repeated all over
   LoadW VERA_L0_config, VERA_Bitmap_Mode + VERA_colors_256
   LoadB VERA_L0_tilebase, VERA_tile_width_16

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

   stz VERA_ctrl           ; dcsel and adrsel both to 0

   rts
.endproc
