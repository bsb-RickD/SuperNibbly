.ifndef DROPPING_NIBBLY_ASM
DROPPING_NIBBLY_ASM = 1

.ifndef SPRITES_ASM
.include "sprites.asm"
.endif

.ifndef sprite_smoke_0 
.include "intro/intro_sprites.inc" 
.endif

init_drop_y_positions:
.word neg_word(89), neg_word(98), neg_word(107), neg_word(108), neg_word(106), neg_word(96)
init_drop_timings:
.byte 1,10

.proc init_drop
   ; reset y positions
   LoadW R0,init_drop_y_positions
   LoadW R1,dropping_n+4
   ldx #6
   ldy #1
next_letter_pos:
   lda (R0)
   sta (R1)
   lda (R0),y
   sta (R1),y
   AddVW 2, R0
   AddVW 11, R1
   dex
   bne next_letter_pos
   
   ; reset speeds
   LoadW R1,dropping_n
   ldx #6
next_letter_speed:
   lda (R0)
   sta (R1)
   lda (R0),y
   sta (R1),y
   AddVW 11, R1
   dex
   bne next_letter_speed

   rts
.endproc

.proc drop_letter
   ldy #1
   lda (R15),y       ; load current speed
   ldy #4            ; move y to.. well, the y position of the sprite
   clc
   adc (R15),y 
   sta (R15),y
   iny
   lda (R15),y
   adc #0
   sta (R15),y       ; y pos updated and stored
   lda (R15)
   dec 
   sta (R15)
   beq switch_speed
not_done_yet:   
   AddVW 2,R15
   jsr show_sprite   ; show the sprite
   clc
   rts
switch_speed:
   ldy #1
   lda (R15),y       ; get current speed
   add #2            ; increase it
   cmp #20           ; max speed reached?
   beq done          ; yep, stop
   sta (R15),y       ; .. otherwise: store new speed
   lda #4
   sta (R15)         ; set count back to 4
   bra not_done_yet
done:
   sec   
   rts
.endproc

; oversize sprite example class definition
;
; -------------------------------------- we start with the oversize sprite def ----------------------------
; .word 240,87         ; 0-3: position
; .addr sprite_smoke_0 ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 6              ; 8:   number of sprites in this oversize sprite

dropping_n:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 25,neg_word(89)   ; 0-3: position
.addr sprite_n_0_0      ; 4,5: sprite frame pointer
.word spritenum(114)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

dropping_i:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 67,neg_word(98)   ; 0-3: position
.addr sprite_i_0_0      ; 4,5: sprite frame pointer
.word spritenum(116)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

dropping_b1:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 93,neg_word(107)  ; 0-3: position
.addr sprite_b1_0_0     ; 4,5: sprite frame pointer
.word spritenum(118)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

dropping_b2:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 149,neg_word(108) ; 0-3: position
.addr sprite_b2_0_0     ; 4,5: sprite frame pointer
.word spritenum(124)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

dropping_l:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 201,neg_word(106) ; 0-3: position
.addr sprite_l_0_0      ; 4,5: sprite frame pointer
.word spritenum(122)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

dropping_y:
.byte 1                 ; count
.byte 10                ; speed
; ----------- oversize sprite starts here ------------------------
.word 244,neg_word(96)  ; 0-3: position
.addr sprite_y_0_0      ; 4,5: sprite frame pointer
.word spritenum(120)    ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2                 ; 8:   number of sprites in this oversize sprite

                     
.endif