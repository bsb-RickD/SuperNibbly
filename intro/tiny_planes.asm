.ifndef TINY_PLANES_ASM
TINY_PLANES_ASM = 1

.ifndef SPRITES_ASM
.include "lib/sprites.asm"
.endif

; tiny plane movement table for plane 1
; -------- oversize sprite definition -------------------------------------------------------------------------
; .word x,y                          ; 0-3: position
; .addr sprite_plane_0               ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)                ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 1                            ; 8:   number of sprites in this oversize sprite
; -------- movement org data ----------------------------------------------------------------------------------
; .byte count                        ; offset 9 - length of movement table
; .word current                      ; offset 10 - pointer to current data
; -------- actual movement data ------------------------------------------------------------------------------
; .byte x-add, y-add, sprite-frame   ; offset 12 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_1:
   .word unknwn,unknwn               ; x,y - unknwn values are set in the init_planes proc
   .addr unknwn                      ; sprite frame pointer - this gets set dynamically, based on the sprite frame data (3rd column)
   .word spritenum(0)                ; sprite# to use - stored as address of the sprite data in VRAM 
   .byte 1                           ; number of sprites
   ;-----------
   .byte 79                          ; length of movement table below - also initialized in the init function
   .word unknwn                      ; current data ptr
   ;-----------
   .byte 2,0,0                       ; start of movement data
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,255,1
   .byte 2,254,2
   .byte 1,254,3
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 255,254,5
   .byte 254,254,6
   .byte 254,255,7
   .byte 254,255,7
   .byte 254,255,7
   .byte 254,255,7
   .byte 254,255,7
   .byte 254,255,7
   .byte 254,254,6
   .byte 255,254,5
   .byte 0,254,4
   .byte 0,254,4
   .byte 1,254,3
   .byte 1,254,3
   .byte 2,254,2
   .byte 2,254,2
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,254,2
   .byte 2,254,2
   .byte 2,254,2
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,251,0

; tiny plane movement table for plane 2
; -------- oversize sprite definition -------------------------------------------------------------------------
; .word x,y                          ; 0-3: position
; .addr sprite_plane_0               ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)                ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 1                            ; 8:   number of sprites in this oversize sprite
; -------- movement org data ----------------------------------------------------------------------------------
; .byte count                        ; offset 9 - length of movement table
; .word current                      ; offset 10 - pointer to current data
; -------- actual movement data ------------------------------------------------------------------------------
; .byte x-add, y-add, sprite-frame   ; offset 12 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_2:
   .word unknwn,unknwn               ; x,y - unknwn values are set in the init_planes proc
   .addr unknwn                      ; sprite frame pointer - this gets set dynamically, based on the sprite frame data (3rd column)
   .word spritenum(1)                ; sprite# to use - stored as address of the sprite data in VRAM 
   .byte 1                           ; number of sprites
   ;-----------
   .byte 137                         ; length of movement table below - also initialized in the init function
   .word unknwn                      ; current data ptr
   ;-----------
   .byte 0,0,0                       ; start of movement data
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,0,0
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 1,3,13
   .byte 2,2,14
   .byte 3,1,15
   .byte 2,255,0
   .byte 2,255,1
   .byte 1,254,2
   .byte 0,254,3
   .byte 255,254,4
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 254,254,6
   .byte 254,255,7
   .byte 254,0,8
   .byte 254,1,9
   .byte 254,2,10
   .byte 255,3,11
   .byte 0,3,12
   .byte 1,3,13
   .byte 2,3,14
   .byte 3,2,15
   .byte 3,2,15
   .byte 3,1,15
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,0,0
   .byte 3,1,15
   .byte 2,2,14
   .byte 1,2,13
   .byte 0,3,12
   .byte 255,2,11
   .byte 254,1,10
   .byte 254,0,8
   .byte 254,255,7
   .byte 254,254,6
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 0,254,4
   .byte 1,254,3
   .byte 2,2,2
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,0,0
   .byte 2,1,15
   .byte 2,2,14
   .byte 2,3,13
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
   .byte 255,2,11
   .byte 254,2,10
   .byte 254,1,9
   .byte 254,0,8
   .byte 254,0,8
   .byte 254,255,7
   .byte 254,254,6
   .byte 254,254,6
   .byte 254,254,6
   .byte 254,254,6
   .byte 254,254,6
   .byte 254,254,6
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,254,4
   .byte 0,251,0

; tiny plane movement table for plane 3
; -------- oversize sprite definition -------------------------------------------------------------------------
; .word x,y                          ; 0-3: position
; .addr sprite_plane_0               ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)                ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 1                            ; 8:   number of sprites in this oversize sprite
; -------- movement org data ----------------------------------------------------------------------------------
; .byte count                        ; offset 9 - length of movement table
; .word current                      ; offset 10 - pointer to current data
; -------- actual movement data ------------------------------------------------------------------------------
; .byte x-add, y-add, sprite-frame   ; offset 12 plus - the actual data
;    (x and y add are signed bytes)
plane_movement_3:
   .word unknwn,unknwn               ; x,y - unknwn values are set in the init_planes proc
   .addr unknwn                      ; sprite frame pointer - this gets set dynamically, based on the sprite frame data (3rd column)
   .word spritenum(2)                ; sprite# to use - stored as address of the sprite data in VRAM 
   .byte 1                           ; number of sprites
   ;-----------
   .byte 113                         ; length of movement table below - also initialized in the init function
   .word unknwn                      ; current data ptr
   ;-----------
   .byte 255,3,11                    ; start of movement data
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 254,2,10
   .byte 254,2,9
   .byte 254,1,9
   .byte 254,1,9
   .byte 254,1,9
   .byte 254,0,8
   .byte 254,0,8
   .byte 254,1,7
   .byte 254,1,7
   .byte 254,254,6
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 0,254,4
   .byte 1,254,3
   .byte 2,254,2
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,254,2
   .byte 0,254,4
   .byte 254,255,6
   .byte 254,0,8
   .byte 254,1,10
   .byte 254,1,10
   .byte 254,1,10
   .byte 254,1,10
   .byte 1,3,12
   .byte 1,3,13
   .byte 2,2,14
   .byte 2,1,15
   .byte 3,2,0
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,0,0
   .byte 2,1,15
   .byte 2,2,14
   .byte 1,3,13
   .byte 3,0,12
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 255,3,11
   .byte 254,2,10
   .byte 254,1,9
   .byte 254,0,8
   .byte 254,0,8
   .byte 254,0,8
   .byte 254,0,8
   .byte 254,255,7
   .byte 254,254,6
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 255,254,5
   .byte 0,254,4
   .byte 1,254,3
   .byte 2,254,2
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,255,1
   .byte 2,254,2
   .byte 2,254,2
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 1,254,3
   .byte 0,251,0


.proc init_planes
   LoadW plane_movement_1+0, 0
   LoadW plane_movement_1+2, 80
   LoadB plane_movement_1+9, 79
   LoadW plane_movement_1+10, plane_movement_1+12

   LoadW plane_movement_2+0, 78
   LoadW plane_movement_2+2, 8
   LoadB plane_movement_2+9, 137
   LoadW plane_movement_2+10, plane_movement_2+12

   LoadW plane_movement_3+0, 170
   LoadW plane_movement_3+2, 8
   LoadB plane_movement_3+9, 113
   LoadW plane_movement_3+10, plane_movement_3+12
   rts
.endproc

.endif