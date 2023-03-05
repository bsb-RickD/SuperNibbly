.ifndef TRAVEL_FUNCTION_PTRS_INC
TRAVEL_FUNCTION_PTRS_INC = 1

.ifndef WORK_QUEUE_INC
.include "inc/work_queue.inc"
.endif

.ifndef TRAVEL_DEFS_INC
.include "travel/travel_defs.inc"
.endif

.import travel_left

TRAVEL_FPB = *                            ; intro function pointer base
TRAVEL_FPI = ((TRAVEL_FPB-function_ptrs)/8)

   .word travel_left, mountain_bg_0       ; 0 
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_1       ; 1
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_2       ; 2
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_bg_3       ; 3
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_0       ; 4 
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_1       ; 5
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_2       ; 6
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, mountain_fg_3       ; 7
   no_commands_to_add                     ; nothing, mountains just travel on and on..

   .word travel_left, tree_bg_0           ; 8
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_1           ; 9
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_2           ; 10
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_3           ; 11
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_4           ; 12
   no_commands_to_add                     ; 

   .word travel_left, tree_bg_5           ; 13
   no_commands_to_add                     ; 

   .word travel_left, house_bg_0          ; 14
   no_commands_to_add                     ; 

   .word travel_left, house_bg_1          ; 15
   no_commands_to_add                     ; 

   .word travel_left, house_fg_0          ; 16
   no_commands_to_add                     ; 

   .word travel_left, house_fg_1          ; 17
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_0           ; 18
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_1           ; 19
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_2           ; 20
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_3           ; 21
   no_commands_to_add                     ; 

   .word travel_left, tree_fg_4           ; 22
   no_commands_to_add                     ; 



landscape_sprites:
.include "travel/travel_landscape_sprites.inc"

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