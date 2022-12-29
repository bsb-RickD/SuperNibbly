.ifndef DROPPING_NIBBLY_ASM
DROPPING_NIBBLY_ASM = 1

.ifndef SPRITES_ASM
.include "sprites.asm"
.endif

.ifndef sprite_smoke_0 
.include "intro/intro_sprites.inc" 
.endif

.proc drop_n
   LoadW R15, dropping_n
   jsr show_sprite
   LoadW R15, dropping_i
   jsr show_sprite
   LoadW R15, dropping_b1
   jsr show_sprite
   LoadW R15, dropping_b2
   jsr show_sprite
   LoadW R15, dropping_l
   jsr show_sprite
   LoadW R15, dropping_y
   jsr show_sprite
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
.word 25,141         ; 0-3: position
.addr sprite_n_0_0   ; 4,5: sprite frame pointer
.word spritenum(4)   ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

dropping_i:
.word 67,132         ; 0-3: position
.addr sprite_i_0_0   ; 4,5: sprite frame pointer
.word spritenum(6)   ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

dropping_b1:
.word 93,123         ; 0-3: position
.addr sprite_b1_0_0  ; 4,5: sprite frame pointer
.word spritenum(8)   ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

dropping_b2:
.word 149,122        ; 0-3: position
.addr sprite_b2_0_0  ; 4,5: sprite frame pointer
.word spritenum(14)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

dropping_l:
.word 201,124        ; 0-3: position
.addr sprite_l_0_0   ; 4,5: sprite frame pointer
.word spritenum(12)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

dropping_y:
.word 244,134        ; 0-3: position
.addr sprite_y_0_0   ; 4,5: sprite frame pointer
.word spritenum(10)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 2              ; 8:   number of sprites in this oversize sprite

                     
.endif