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
   .byte 0,3,12
   .byte 0,3,12
   .byte 0,3,12
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


plane_delay:
.byte  21

;
; Animate plane according to the movement data
; 
; R15 points to a plane movement structure
;
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
.proc move_plane
   lda plane_delay
   dec 
   sta plane_delay
   cmp #3
   bgt once_more
   cmp #0
   bne do_it
   lda #21
   sta plane_delay
do_it:   

   ThisLoadW R15,R14,10,-            ; load current ptr into R14
   ThisLoadW R14,R0,0                ; load x,y add into R0
   ThisLoadB R14,R1L,-               ; load sprite anim frame into R1L
   AddVW 3,R14                       ; increment R14 by 3 - this becomes the new current pointer
   ThisStoreW R15,R14,10,-           ; update current ptr

   lda R0L                           ; get x add value into a
   ldy #0                            ; y to point to x pos
   jsr signed_add_byte_to_word       ; add, update x word, y to point to y pos
   lda R0H                           ; get y add value into a
   jsr signed_add_byte_to_word       ; add, update y word, y to point to sprite address

   lda R1L                           ; bring in sprite index
   asl
   sta R1L                           ; times 2, carry clear
   asl
   asl
   adc R1L                           ; times 10, carry clear
   sta R1L
   lda #.lobyte(sprite_plane_0)
   adc R1L                           ; add index*10 to sprite_plane_0 address
   sta (R15),y                       ; lobyte of sprite frame
   lda #.hibyte(sprite_plane_0)
   adc #0
   iny
   sta (R15),y                       ; hibyte of sprite frame

   jsr show_sprite                   ; housekeeping done, positions updated, sprite frame selected, show the sprite!

   ldy #9                            ; 9 = position of count
   lda (R15),y
   dec
   sta (R15),y                       ; store decremented count
   beq done
once_more:
   clc
   rts
done:
   sec
   rts

; add a to word at R15,y
signed_add_byte_to_word:
   cmp #$80
   blt unsigned
   clc
   adc (R15),y
   sta (R15),y
   iny
   lda (R15),y
   adc #255
   sta (R15),y
   bra add_done
unsigned:
   adc (R15),y
   sta (R15),y
   iny
   bcc add_done
   lda (R15),y
   inc
   sta (R15),y
add_done:
   iny  
   rts
.endproc

.proc init_tiny_planes
   LoadW plane_movement_1+0, neg_word(20)
   LoadW plane_movement_1+2, 67
   LoadB plane_movement_1+9, 79
   LoadW plane_movement_1+10, plane_movement_1+12

   LoadW plane_movement_2+0, 58
   LoadW plane_movement_2+2, neg_word(14)
   LoadB plane_movement_2+9, 137
   LoadW plane_movement_2+10, plane_movement_2+12

   LoadW plane_movement_3+0, 150
   LoadW plane_movement_3+2, neg_word(5)
   LoadB plane_movement_3+9, 113
   LoadW plane_movement_3+10, plane_movement_3+12
   rts
.endproc

.endif