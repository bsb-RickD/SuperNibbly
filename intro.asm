.org $080D
.segment "ONCE"
.segment "CODE"

.feature c_comments
.linecont +

   jmp main

; to switch vsync irq and palette fading on or off
;USE_IRQ = 1 ; comment the line to turn off

; to use compressed assets or not
DECOMPRESS_BG = 1
DECOMPRESS_TO_MEM = 1

.include "kernal_constants.asm"
.include "helpers.asm"
.include "vera.asm"
.ifdef USE_IRQ
.include "irq.asm"
.endif

   
; constants
FramesToWait      = 5


color:   .byte 0
inc_dec: .byte 1
bgcol:   .byte 0,0

c64_pal: .byte $00,$0,$ff,$f,$00,$8,$fe,$a,$4c,$c,$c5,$0,$0a,$0,$e7,$e,$85,$d,$40,$6,$77,$f,$33,$3,$77,$7,$f6,$a,$8f,$0,$bb,$b

filename_in: .byte   "in.bin",0
filename_out: .byte  "out.bin",0

.proc main
   ; init state for multiple runs to be consistent
   stz color
   mob #1,inc_dec
   stz bgcol
   stz bgcol+1

.ifdef USE_IRQ
   ; save irq, and install our custom_irq
   mow #custom_irq, R0
   jsr init_irq
.endif

   jsr switch_to_tiled_mode
   jsr fill_screen

repeat:   
   jsr KRNL_GETIN    ; read key
   cmp KEY_Q         
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
   jsr reset_irq
.endif   
   jsr switch_to_textmode   
   
   rts
.endproc



.proc switch_to_tiled_mode
   lda VERA_dc_video
   and #7                  ; keep video and chroma mode
   ora #$10                ; layer 0 = on, sprites = off, layer 1 = off
   sta VERA_dc_video       ; set it
   stz VERA_ctrl           ; dcsel and adrsel both to 0
   mob #64, VERA_dc_hscale ; 2 pixel output     
   sta VERA_dc_vscale      ; 320 x 240   
   ; map 64x32, 16 colors, starting at 0, tiles start at 4k, 8x8
   mob #VERA_map_height_32 + \
      VERA_map_width_64 + \
      VERA_colors_16, VERA_L0_config
   stz VERA_L0_mapbase   
   mob #((4096/2048) << 2) + VERA_tile_width_8 + VERA_tile_height_8, VERA_L0_tilebase     

   ; set palette
   mow #screen_pal, R11
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
   mob #128, VERA_dc_hscale   ; 1 pixel output 
   sta VERA_dc_vscale         ; 640 x 480   
   ; map 128x64, 1bpp colors (textmode)
   mob #VERA_map_height_64 + \
       VERA_map_width_128 + \
       VERA_colors_2, VERA_L1_config   

   ; restore default palette   
   mow #c64_pal, R11
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
   set_vera_address 0,0,VERA_increment_1,0   
   mow #screen, R0         ; screendata to R0 (source)        
   mow #VERA_data0, R1     ; vera data #0 to R1 (destination)
.ifdef DECOMPRESS_BG
.ifdef DECOMPRESS_TO_MEM
   mow #decompress, R1     ; decompress to mem R1 (destination)
.endif
   ;jsr KRNL_MEM_DECOMPRESS
   jsr memory_decompress
.ifdef DECOMPRESS_TO_MEM   
   sec                     ; r1 now points to output+1
   lda R1
   sbc #<decompress        ; subtract start of buffer to get length of data to copy
   sta R2                  ; store it in r2
   lda R1+1
   sbc #>decompress
   sta R2+1
   mow #decompress, R0     ; source
   mow #VERA_data0, R1     ; vera data #0 to R1 (destination)
   jsr KRNL_MEM_COPY
.endif   
.else   
   mow #SCREEN_SIZE, R2
   jsr KRNL_MEM_COPY
.endif

   rts   
.endproc

.ifdef USE_IRQ
vsync_count: .word 0

.proc custom_irq
   php                                 ; save flags
   sei                                 ; disable interrupts
   lda VERA_isr
   and #1                              ; check vsync bit
   beq done                            ; bit 1 not set - no vsync

   ; we have a vsync - increase the vsync_count
   inc vsync_count
   bne custom_code
   inc vsync_count+1                   ; overflow into second byte
 custom_code:   
   ; here comes the custom code   
   jsr push_vera_address               ; save the state
   mow #bgcol, R11                     ; write address of bgcol to R0
   ldx #0                              ; copy only 1 color
   lda #6                              ; color 6 is start index
   jsr write_to_palette                
   jsr pop_vera_address                ; pop the state
 done:
   plp                                 ; don't re-enable interrupts, the flag knows the prev state anyhow
   jmp (default_irq)
.endproc   

.proc wait_for_vsync
   cmp vsync_count
   beq wait_irq          ; vsync_count still zero? must have been some other IRQ
   stz vsync_count
   rts
 wait_irq:
   wai
   bra wait_for_vsync
.endproc
.endif

.include "lzsa.s"

screen:
.ifdef DECOMPRESS_BG
   .incbin "test.cpr"
.else
   .incbin "test.bin"
.endif

/*
.ifdef DECOMPRESS_BG
   .incbin "intro_bg.bin"
.else
   .incbin "intro_back.bin"
.endif
*/
SCREEN_SIZE = *-screen

screen_pal:
.incbin "palette.bin"
PALETTE_SIZE = *-screen_pal

decompress:
.byte 255