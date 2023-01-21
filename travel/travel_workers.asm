.ifndef TRAVEL_WORKERS_ASM
TRAVEL_WORKERS_ASM = 1

landscape_sprites:
.include "travel/travel_landscape_sprites.inc"

TRAVEL_SP_SHIFT  = 3
TRAVEL_SUBPIXEL  = 1<<TRAVEL_SP_SHIFT


; R15 pointer to a moving sprite
.proc travel_left   
   ThisLoadW R15,R0,0,-    ; R0 is now the pos stored at R15
   lda R0L
   ldy #2
   sec
   sbc (R15),y             ; subtract decrement
   sta R0L                 ; lo-word done
   lda R0H
   sbc #0
   sta R0H                 ; high-word done

   ; have we left the frame entirely?
   CmpBI R0H, .hibyte(neg_word((32-11)*TRAVEL_SUBPIXEL))
   bne store_updated_value ; high bytes don't macht - just carry on
   CmpBI R0L, .lobyte(neg_word((32-11)*TRAVEL_SUBPIXEL))
   ble wrap_around         ; yes, wrap around
store_updated_value:   
   ThisStoreW R15, R0, 0,- ; store updated value in our structure
   AsrW R0,::TRAVEL_SP_SHIFT ; shift right and store the result
   ThisStoreW R15, R0, 4,- ; store as sprite pos
   AddVW 4,R15             ; advance the pointer to the sprite structure
   jsr show_sprite         ; show the sprite
   clc                     ; indicate we want to carry on 
   rts
wrap_around:
   ; ok, an absurd coincindence happened here: we need to add 128, because we need to add 4*32* = 128
   ; with the sub pixel resolution it becomes a multiple of 256, so we only need to increment the high word..
   ldy #3
   lda (R15),y             ; get increment
   add R0H                 ; add to high word
   sta R0H
   bra store_updated_value ; write it back..
.endproc

MBG_SP = 6
MFG_SP = 8
TBG_SP = 16
RD_SP  = 18
TFG_SP = 22

mountain_bg_0:
.word 11*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MBG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 11,14                      ; 0-3: position
.addr sprite_mountain_bg_0       ; 4,5: sprite frame pointer
.word spritenum(124)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_bg_1:
.word 43*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MBG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 43,14                      ; 0-3: position
.addr sprite_mountain_bg_1       ; 4,5: sprite frame pointer
.word spritenum(125)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_bg_2:
.word 75*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MBG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 75,14                      ; 0-3: position
.addr sprite_mountain_bg_2       ; 4,5: sprite frame pointer
.word spritenum(126)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_bg_3:
.word 107*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte MBG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 107,14                     ; 0-3: position
.addr sprite_mountain_bg_0       ; 4,5: sprite frame pointer
.word spritenum(127)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_fg_0:
.word 11*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MFG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 11,30                      ; 0-3: position
.addr sprite_mountain_fg_0       ; 4,5: sprite frame pointer
.word spritenum(120)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_fg_1:
.word 43*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MFG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 43,30                      ; 0-3: position
.addr sprite_mountain_fg_1       ; 4,5: sprite frame pointer
.word spritenum(121)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_fg_2:
.word 75*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte MFG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 75,30                      ; 0-3: position
.addr sprite_mountain_fg_2       ; 4,5: sprite frame pointer
.word spritenum(122)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

mountain_fg_3:
.word 107*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte MFG_SP                     ; 2  : decrement 
.byte (128*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 107,30                     ; 0-3: position
.addr sprite_mountain_fg_0       ; 4,5: sprite frame pointer
.word spritenum(123)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_0:
.word 20*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(119)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_1:
.word 52*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(118)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_2:
.word 92*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(117)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_3:
.word 130*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(116)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_4:
.word 150*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(115)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_bg_5:
.word 210*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,29                       ; 0-3: position
.addr sprite_trees_1             ; 4,5: sprite frame pointer
.word spritenum(114)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

house_bg_0:
.word 70*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,21                       ; 0-3: position
.addr sprite_houses_1            ; 4,5: sprite frame pointer
.word spritenum(113)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

house_bg_1:
.word 180*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TBG_SP                     ; 2  : decrement 
.byte (256*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,21                       ; 0-3: position
.addr sprite_houses_1            ; 4,5: sprite frame pointer
.word spritenum(112)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

house_fg_0:
.word 190*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,31                       ; 0-3: position
.addr sprite_houses_0            ; 4,5: sprite frame pointer
.word spritenum(111)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

house_fg_1:
.word 400*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,31                       ; 0-3: position
.addr sprite_houses_0            ; 4,5: sprite frame pointer
.word spritenum(110)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_fg_0:
.word 20*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,40                       ; 0-3: position
.addr sprite_trees_0             ; 4,5: sprite frame pointer
.word spritenum(109)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_fg_1:
.word 100*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,40                       ; 0-3: position
.addr sprite_trees_0             ; 4,5: sprite frame pointer
.word spritenum(108)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_fg_2:
.word 220*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,40                       ; 0-3: position
.addr sprite_trees_0             ; 4,5: sprite frame pointer
.word spritenum(107)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_fg_3:
.word 300*TRAVEL_SUBPIXEL        ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,40                       ; 0-3: position
.addr sprite_trees_0             ; 4,5: sprite frame pointer
.word spritenum(106)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

tree_fg_4:
.word 440*TRAVEL_SUBPIXEL         ; 0,1: pos x *2
.byte TFG_SP                     ; 2  : decrement 
.byte (512*TRAVEL_SUBPIXEL)>>8   ; 3  : wrap around increment
; ------------ sprite structure starts here -----------------------------
.word 0,40                       ; 0-3: position
.addr sprite_trees_0             ; 4,5: sprite frame pointer
.word spritenum(105)             ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 1                          ; 8:   number of sprites in this oversize sprite

.endif