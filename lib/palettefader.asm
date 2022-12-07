.ifndef palettefader_start_fade

.include "common.inc"

; palette fader class layout
;
; num colors to fade       1 byte   (+1, 0 meaning 1, etc.)
; pointer to palette       2 bytes
; target color             2 bytes
; state                    1 byte   (up/down/done)
; current f                1 byte   (0..16)
;
; methods:
;     start_fade     carry specifies direction 0: fade towards target color, 1: fade from target color
;     step_fade      register specifies output buffer, carry 0: not done yet, carry 1: fade complete

; R15: this pointer
; c = 0: fade towards target color, 1: fade from target color
.proc palettefader_start_fade
   ldy #5                  ; point to state
   bcs fade_from_target
   lda #1
   ldx #0
   bra set_state_and_f
fade_from_target:
   lda #$FF
   ldy #16
set_state_and_f:   
   sta (R15),y             ; set state to increment / decrement
   iny
   txa
   sta (R15),y             ; set f to 0/16
   rts
.endproc

.endif