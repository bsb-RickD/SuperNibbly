.ifndef FILEIO_ASM
FILEIO_ASM = 1

ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG = $0A

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

; in:
;  R11 points to filename, zero terminated
; out:
;  c clear: success
; 
;  c set: fail
;     a holds kernal error code or ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
.proc file_set_lfs_and_name
   lda #1         ; Logical Number = 1
   ldx #8         ; Device = "SD card" (emulation host FS)
   ldy #0         ; Secondary Address = 0, meaning we can specify where to load to on LOAD
   jsr KRNL_SETLFS   
   phw R11
   jsr str_len
   plw R11
   bcs prev_error ; error detected upstream, bail out
   cpx #0         ; if x > 0 - then the filename is longer than 255 bytes
   bne error
   tya            ; a = filename length
   clc
   ldx R11
   ldy R11+1
   jmp KRNL_SETNAM   ; we jump there, and kernal will do the rts to the caller
error:   
   lda #ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
   sec
prev_error:   
   rts
.endproc

; in:
;  R11 points to filename, zero terminated
;  R12 points to location to load to
; out:
;  c clear: success
;     x,y hold end of load: x low, y high
;  c set: fail
;     a holds kernal error code or ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
.proc file_load
   jsr file_set_lfs_and_name  ; prepare file operation
   bcs error
   lda #0                     ; load
   ldx R12                    ; lo-byte where to load to
   ldy R12+1                  ; hi-byte where to load to
   jmp KRNL_LOAD              ; kernal will do the rts to our caller
error:   
   rts
.endproc

; in:
;  R11 points to filename, zero terminated
;  R12 points to the memory to save
;  R13 point to the end of the memory
; out:
;  c clear: success
; 
;  c set: fail
;     a holds kernal error code or ERR_STRING_NOT_ZERO_TERMINATED_OR_TOO_LONG
.proc file_save
   jsr file_set_lfs_and_name  ; prepare file operation
   bcs error
   lda #R12                   ; (a) is the addess to save
   ldx R13                    ; lo-byte
   ldy R13+1                  ; hi-byte
   jmp KRNL_SAVE              ; kernal will do the rts to our caller
error:   
   rts
.endproc

.endif
