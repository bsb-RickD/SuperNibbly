;+; Hello world in Commodore 64 Assembler - runs automatically
;; for 64Tass assembler from https://sourceforge.net/projects/tass64/
;; Initial BASIC stub adapted from http://tass64.sourceforge.net/

*       = $0801
        .word (+), 10  ;pointer, line number
        .null $9e, format("%d", start) ;will be sys 2061
+	.word 0          ;basic line end

SubW3 .macro source, sorv, dest
        lda \source
        sec
.if str(\sorv)[0] == '#'
        ; it's an immediate value
        sbc <\sorv
        sta \dest
        lda \source+1
        sbc >\sorv
.else
        ; assume absolute or zero page for sorv
        sbc \sorv
        sta \dest
        lda \source+1
        sbc \sorv+1
.endif        
        sta \dest+1

.endmacro


start:
        ldy #0
loop:   lda message, y
        jsr $ffd2
        iny
        cpy #15
        bne loop

        #SubW3 $02, #$AABB, $06

        #SubW3 $02, 4, $06

        rts
        
message: .byte 147 
        .text "hello world!"
        .byte 13
        .byte 10


sprite_smoke_2  .struct
x_offset        .byte 3
y_offset        .byte 2
address         .word 686
                .endstruct

sprite_smoke_3  .struct
x_offset        .byte 0
y_offset        .byte 0
address         .word 686+32
                .endstruct
