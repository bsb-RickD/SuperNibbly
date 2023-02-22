.ifndef FILEIO_ASM
FILEIO_ASM = 1

.ifndef COMMON_INC
.include "inc/common.inc"
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
;  c set:   fail     -> a,x holds status and kernal error code
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
   ; read status byte - this should be zero
   pha
   jsr KRNL_READST   ; a = status byte
   plx
   cmp #0
   bne report_error
   clc
   rts
error:
   ; error condition - remember kernal error in x and get the status word on top 
   pha
   jsr KRNL_READST   ; a = status byte
   plx               ; x = previous kernal error code
report_error:   
   sec               ; carry set - something was fishy
   rts   
.endproc

; currently just assumes logical file 1 has been opened
; 
.proc file_close
   lda #1         ; Logical file Number = 1
   jsr KRNL_CLOSE
   rts   
.endproc

; in:
;  R0 = address to load to
;  R1L = bank (used if R0 points into the $A000-$BFFF)
; 
;  R2L, R2H, R1H = max bytes to load
;
.proc file_read
   ldx R0L              ; move address ..
   ldy R0H              ; ... to x and y
   cpy #$A0
   blt no_bank
   lda R1L
   sta BANK
no_bank:      
keep_loading:   
   lda R1H
   bne load_amap  
   lda R2H
   bne load_amap
   lda R2L              ; load only the last few bytes
   beq finished         ; if it's zero, we're done
   bra load_last_bit
load_amap:              
   lda #0               ; load as much as possible..
load_last_bit:
   clc                  ; increase the output addresse
   jsr KRNL_MACPTR   
   bcs error            ; was there a problem?
   jsr KRNL_READST      ; read status
   cmp #64              ; End of file reached?
   beq finished
   cmp #0
   bne error            ; some error condition occured, abort
   txa         
   add R0L              ; advance address
   sta R0L
   tya
   adc R0H              ; update high byte
   sta R0H              ; R0 is now the new address to load to
   cmp #$BF             ; have we left the 8k page range?
   ble no_bank_switch
   sub #32              
   sta R0H              ; R0 is now the final address to load to
   inc BANK
no_bank_switch:   
   lda R2L              ; update the number of bytes to load
   stx R1L
   sub R1L
   sta R2L              ; new low byte
   lda R2H
   sty R1L
   sbc R1L
   sta R2H              ; new high byte
   lda R1H
   sbc #0
   sta R1H              ; new bank byte
   ldx R0L              ; load new load position in x ...
   ldy R0H              ; ... and y 
   bra keep_loading
finished:
   clc
   rts
error:
   sec   
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
