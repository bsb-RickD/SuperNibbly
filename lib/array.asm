.ifndef array_append

.include "regs.inc"
.include "mac.inc"

; R15 - pointer to the array
; a - the value to add
;
; a gets changed, R15,x,y are unchanged
.proc array_append
   phy
   pha
   ; incrase size counter
   lda (R15)
   inc 
   sta (R15)
   tay                  ; y = index where to store the new item to.
   pla                  ; pull the item to add
   sta (R15),y          ; finally, store it..
   ply   
   rts
.endproc

; R15 - pointer to the array
; a - the value to remove (only the first found occurrence gets removed)
;
; a,R14 gets changed, R15,x,y are unchanged
.proc array_remove
   phx                  ; save x
   phy                  ; and y 

   tay                  ; remember what to remove
   lda (R15)
   beq nothing_found    ; array empty? get out of here
   tax                  ; remember length in x
   tya                  ; a = the value to remove
   ldy #1               ; start at index 1 (0 = length of array)
loop:   
   cmp (R15),y
   beq remove_it        ; we found it - remove it
   iny
   dex                  ; modify counter and index
   cpx #0
   bne loop             ; repeat until we're done
nothing_found:   
   bra exit             ; nothing found - return
remove_it:
   cpx #1              
   beq decrease_size    ; only one item from end? - this means we're removing the last item. No need to copy data around, just decrease the size
   lda R15L
   sub #1               
   sta R14L
   lda R15H
   sbc #0
   sta R14H             ; R14 = R15-1
remove_loop:   
   iny
   dex
   lda (R15),y          ; read from R15
   sta (R14),y          ; copy it to the byte before
   cpx #1
   bne remove_loop
decrease_size:
   lda (R15)            ; decrease the length attribute at index 0
   dec
   sta (R15)   

exit:
   ply                  ; restore y
   plx                  ; and x
   rts
.endproc

.endif