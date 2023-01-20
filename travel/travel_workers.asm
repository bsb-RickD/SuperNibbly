.ifndef TRAVEL_WORKERS_ASM
TRAVEL_WORKERS_ASM = 1

.include "travel/travel_landscape_sprites.inc"

TRAVEL_SUBPIXEL  = 2

; R15 pointer to a moving sprite
.proc travel_left   
   lda (R15)               ; load low byte of pos
   sec
   ldy #2
   sbc (R15),y             ; subtract decrement
   sta (R15)               ; store it
   tax                     ; remember low word in x
   dey
   lda (R15),y             ; load high word
   sbc #0                  ; complete subtraction
   sta (R15),y             ; store it
   cmp #$FF
   bne store_in_sprite     ; if the high word is positive, carry on..
   cpx #neg_byte(42)       ; compare low word with -21 (times two)
   beq wrap_around
   bmi wrap_around
store_in_sprite:   
   asr
   tax
   lda (R15)
   ror 
   ldy #3
   sta (R15),y
   iny
   txa
   sta (R15),y
   AddVW 3,R15
   jsr show_sprite
   clc
   rts
wrap_around:
   ; ok, an absurd coincindence happened here: we need to add 256, because we need to add 4*32*2 = 256
   ; so we don't need to do anything with the lo word, which has already been stored, just need to inc the high word..
   ldy #1
   lda (R15),y
   inc
   sta (R15),y
   bra store_in_sprite   
.endproc


mountain_bg_0:
.word 11*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 1                    ; 2  : decrement 
; ------------ sprites starts here
.word 11,14                ; 0-3: position
.addr sprite_mountain_bg_0 ; 4,5: sprite frame pointer
.word spritenum(124)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_bg_1:
.word 43*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 1                    ; 2  : decrement 
; ------------ sprites starts here
.word 43,14                ; 0-3: position
.addr sprite_mountain_bg_1 ; 4,5: sprite frame pointer
.word spritenum(125)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_bg_2:
.word 75*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 1                    ; 2  : decrement 
; ------------ sprites starts here
.word 75,14                ; 0-3: position
.addr sprite_mountain_bg_2 ; 4,5: sprite frame pointer
.word spritenum(126)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_bg_3:
.word 107*TRAVEL_SUBPIXEL  ; 0,1: pos x *2
.byte 1                    ; 2  : decrement 
; ------------ sprites starts here
.word 107,14               ; 0-3: position
.addr sprite_mountain_bg_0 ; 4,5: sprite frame pointer
.word spritenum(127)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_fg_0:
.word 11*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 2                    ; 2  : decrement 
; ------------ sprites starts here
.word 11,30                ; 0-3: position
.addr sprite_mountain_fg_0 ; 4,5: sprite frame pointer
.word spritenum(120)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_fg_1:
.word 43*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 2                    ; 2  : decrement 
; ------------ sprites starts here
.word 43,30                ; 0-3: position
.addr sprite_mountain_fg_1 ; 4,5: sprite frame pointer
.word spritenum(121)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_fg_2:
.word 75*TRAVEL_SUBPIXEL   ; 0,1: pos x *2
.byte 2                    ; 2  : decrement 
; ------------ sprites starts here
.word 75,30                ; 0-3: position
.addr sprite_mountain_fg_2 ; 4,5: sprite frame pointer
.word spritenum(122)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

mountain_fg_3:
.word 107*TRAVEL_SUBPIXEL  ; 0,1: pos x *2
.byte 2                    ; 2  : decrement 
; ------------ sprites starts here
.word 107,30               ; 0-3: position
.addr sprite_mountain_fg_0 ; 4,5: sprite frame pointer
.word spritenum(123)       ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                    ; 8:   number of sprites in this oversize sprite

.endif