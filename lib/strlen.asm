.ifndef STRLEN_ASM
STRLEN_ASM = 1

.segment "CODE"

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef STRLEN_INC
.include "lib/strlen.inc"
.endif

; R11 points to string
;
; out:
;  c clear: success
;     R11 points to found 0
;     y,x hold length (y: lo-byte, x: hi-byte)
; 
;  c set: fail
;     R11, x, y modified
;     a set to ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
.proc str_len
   ldx #0
   ldy #0
scan:   
   lda (R11),y   
   beq length_found  ; 0 found, y,x hold length
   iny
   bne scan          ; no overflow, carry on
   inc R1+1
   beq error         ; memory overflow? -> error!
   inx
   bra scan
error:
   sec               ; carry to show error
   lda #ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
   rts
length_found:
   clc
   rts
.endproc

.endif
