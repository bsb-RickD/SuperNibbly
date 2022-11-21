.ifndef push_vera_address

.include "zeropage_constants.asm"
.include "vera_constants.asm"
.include "helpers.asm"

; addr = 17 bit address, dataport = 0/1, increment = data increment, direction = 1 for decrement
.macro set_vera_address addr, dataport, increment, direction
.assert (addr) < $1FFFF, error, "when setting vera address, address must be smaller than $1FFFF"
.assert (dataport) = 0 || (dataport) = 1, error, "when setting vera address, dataport must be 0 or 1"
.assert ((increment) >= VERA_increment_0) && ((increment) <= VERA_increment_640), error, "when setting vera address, increment must be between 0 and 15"
.assert (direction) = 0 || (direction) = 1, error, "when setting vera address, direction must be 0 or 1"
   mob #dataport, VERA_ctrl
   mob #((addr) & $FF), VERA_addr_low
   mob #(((addr) >> 8) & $FF), VERA_addr_high
   mob #((((addr) >> 16) & $1) | increment | direction), VERA_addr_bank
.endmacro   

.proc push_current_vera_address
   ; pull return address from stack, and insert it into jump at the end
   ; return address -1 is stored on the stack.. so add 1
   pla
   clc
   adc #1
   sta return+1
   pla 
   adc #0
   sta return+2

   ; now push the 4 address bytes
   lda VERA_ctrl
   pha
   lda VERA_addr_low
   pha
   lda VERA_addr_high
   pha
   lda VERA_addr_bank
   pha
return:
   jmp $AAAA
.endproc

.proc push_both_vera_addresses
   ; pull return address from stack, and insert it into jump at the end
   ; return address -1 is stored on the stack.. so add 1
   pla
   clc
   adc #1
   sta return+1
   pla 
   adc #0
   sta return+2

   ; first push the control byte
   lda VERA_ctrl
   pha

   ; switch to address 0
   and #$FE
   tax
   sta VERA_ctrl   

   ; push the 3 address bytes
   lda VERA_addr_low
   pha
   lda VERA_addr_high
   pha
   lda VERA_addr_bank
   pha

   ; switch to address 1
   txa
   ora #$01
   sta VERA_ctrl

   ; push the 3 address bytes
   lda VERA_addr_low
   pha
   lda VERA_addr_high
   pha
   lda VERA_addr_bank
   pha

return:
   jmp $AAAA
.endproc


.proc pop_current_vera_address
   ; pull return address from stack, and insert it into jump at the end
   ; return address -1 is stored on the stack.. so add 1
   pla
   clc
   adc #1               
   sta return+1
   pla 
   adc #0
   sta return+2

   ; now pop the 4 address bytes
   pla
   sta VERA_addr_bank
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_low
   pla
   sta VERA_ctrl
return:
   jmp $0000
.endproc

.proc pop_both_vera_addresses
   ; pull return address from stack, and insert it into jump at the end
   ; return address -1 is stored on the stack.. so add 1
   pla
   clc
   adc #1               
   sta return+1
   pla 
   adc #0
   sta return+2

   ; switch to address 1
   lda VERA_ctrl
   ora #$01
   tax
   sta VERA_ctrl

   ; now pop the 3 address bytes
   pla
   sta VERA_addr_bank
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_low

   ; switch to address 0
   txa 
   and #$FE
   sta VERA_ctrl

   ; now pop the 3 address bytes
   pla
   sta VERA_addr_bank
   pla
   sta VERA_addr_high
   pla
   sta VERA_addr_low

   ; finally restore control word
   pla
   sta VERA_ctrl
return:
   jmp $AAAA
.endproc


; a = palette index / color# to access
.proc set_vera_data_to_palette
   ldy #1
   sty VERA_ctrl                                ; use data #1 for palette
   asl                                          ; multiply index by 2
   sta VERA_addr_low                            ; store first 8 bit of address
   lda #(VRAM_palette >> 8) & $FF               ; second 8 bit of VRAM_Palette address
   adc #0                               
   sta VERA_addr_high                           ; store it
   lda #(VRAM_palette >> 16)+VERA_increment_1   ; last bit of VRAM_Palette address, increment 1
   sta VERA_addr_bank                           ; store it

   rts
.endproc

; a = palette index / color# to write to
; x = # of colors-1 to write.. so to copy 1 color, set x = 0; to copy 256 colors set x = 255.
; R11 = pointer to color data to be copied to VRAM palette
.proc write_to_palette   
   jsr set_vera_data_to_palette
   ldy #0
   lda (R11),y
   sta VERA_data1
   iny 
   lda (R11),y
   sta VERA_data1
   iny
   txa
   beq done
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
   bne for
done:   
   rts
.endproc

.endif