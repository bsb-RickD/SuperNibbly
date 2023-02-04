.ifndef FILEIO_ASM
FILEIO_ASM = 1

.ifndef KERNAL_INC
.include "inc/kernal.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

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
   PushW R11
   jsr str_len
   PopW R11
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
;  R0 points to filename, leading length string
; out:
;  c clear: success
;  c set:   fail     -> a holds kernal error code
.proc file_open
   lda #1         ; Logical Number = 1
   ldx #8         ; Device = "SD card" (emulation host FS)
   ldy #0         ; Secondary Address = 0, meaning we can specify where to load to on LOAD
   jsr KRNL_SETLFS
   bcs error

   lda (R0)       ; a = length of filename
   ldx R0L        
   ldy R0H        ; move address to x,y
   inx 
   bne no_hi_inc
   iny            
no_hi_inc:        ; here x,y point to the filename - had to inc R0
   jsr KRNL_SETNAM
   bcs error
   jsr KRNL_OPEN  ; open the file
   bcs error
   ;ldx #1         ; logical file numer 
   ;jsr KRNL_CHKIN ; open channel for input
   ;lda #8         ; logical devic number
   ;jsr KRNL_TALK  ; tell it to talk..?
error:   
   rts   
.endproc

; currently just assumes logical file 1 has been opened
; 
.proc file_close
   ;jsr KRNL_CLRCHN
   ;lda #1         ; Logical file Number = 1
   ;jsr KRNL_CLOSE
error:   
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
