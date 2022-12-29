.ifndef JUMPING_FISH_ASM
JUMPING_FISH_ASM = 1

.ifndef SPRITES_ASM
.include "sprites.asm"
.endif

.ifndef sprite_smoke_0 
.include "intro/intro_sprites.inc" 
.endif


; random range parameters
fish_pause_range:
.word 8*16, 15*16                   ; pause range (*16 = number of frames to wait between animations)
.byte 16                            ; pause chunks
.word fish_random_pause_object      ; object to initialize

; random range object
fish_random_pause_object:
.res 5,0                            ; just needs 5 bytes of data

; used for generating the actual pause value
fish_generate_pause:
.word fish_pause_counter            ; generate the random value into this location
.word fish_random_pause_object      ; and use this generator

; used for counting down the pause
fish_pause_counter:
.word 0,0

; random range parameters
fish_x_range:
.word 0, 115                        ; x range
.byte 16                            ; range chunks
.word fish_random_x_object          ; object to initialize

; random range object
fish_random_x_object:
.res 5,0                            ; just needs 5 bytes of data

; used for generating the actual x value
fish_generate_x:
.word jumping_fish+SPR_x_position   ; generate the random value into the x position of the jumping fish
.word fish_random_x_object          ; and use this generator

; random range parameters
fish_y_range:
.word 93, 106                       ; y range
.byte 4                             ; range chunks
.word fish_random_y_object          ; object to initialize

; random range object
fish_random_y_object:
.res 5,0                            ; just needs 5 bytes of data

; used for generating the actual y value
fish_generate_y:
.word jumping_fish+SPR_y_position   ; generate the random value into the y position of the jumping fish
.word fish_random_y_object          ; and use this generator

; animated sprite example class definition
;
; -------------------------------------- we start with the oversize sprite def ----------------------------
; .word 240,87         ; 0-3: position
; .addr sprite_smoke_0 ; 4,5: sprite frame pointer (of first sprite)
; .word spritenum(17)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
; .byte 6              ; 8:   number of sprites in this oversize sprite
; -------------------------------------- additional anim parameters follow --------------------------------
; .byte 0              ; 9:   current anim-frame
; .byte 5              ; 10:  frames to wait before switching to next anim frame 
; .byte 5              ; 11:  current delay count

jumping_fish:
.word 40,100         ; 0-3: position
.addr sprite_fish_0  ; 4,5: sprite frame pointer
.word spritenum(16)  ; 6,7: sprite# to use - stored as address of the sprite data in VRAM 
.byte 17             ; 8:   number of sprites in this oversize sprite
.byte 0              ; 9:   current anim-frame
.byte 6              ; 10:  frames to wait before switching to next anim frame 
.byte 6              ; 11:  current delay count
                     ; 12:  size of struct
.endif