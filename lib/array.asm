.ifndef ARRAY_ASM
ARRAY_ASM = 1

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

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

; append all the elements of another array to this array
;
; R15 - pointer to the array to append to ("this")
; R14 - pointer to the array to append
;
.proc array_append_array
   lda (R14)            ; a = number of elements to append
   beq done
   inc
   sta next+1           ; number of elements to append written to the compare constant
   ldx R14L
   stx copy_loop+1
   ldx R14H
   stx copy_loop+2      ; transfer (R14) to code to store to
   lda (R15)
   tay
   iny                  ; y = position in target array to append to
   lda (R14)
   add (R15)            ; a = new array length
   sta (R15)            ; store it
   ldx #1               ; need to start at 1 - 0 is the length
copy_loop:
   lda $AAAA,x
   sta (R15),y          ; copy the items
   iny
   inx                  ; counter update
next:   
   cpx #$CC
   bne copy_loop
done:
   rts
.endproc


; R15 - pointer to the array
; a - the value to remove (only the first found occurrence gets removed)
;
; a gets changed, R15,x,y are unchanged
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
   sta r15_decreased+1
   lda R15H
   sbc #0
   sta r15_decreased+2  ; address = R15-1
remove_loop:   
   iny
   dex
   lda (R15),y          ; read from R15
r15_decreased:   
   sta $DEC1,y          ; copy it to the byte before
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

; remove all the elements of another array from this array
;
; R15 - pointer to the array to append to ("this")
; R14 - pointer to the array that holds the items to remove
;
.proc array_remove_array
   lda (R14)            ; a = number of elements to remove
   beq done
   tax
   ldy #1
remove_loop:   
   lda (R14),y
   jsr array_remove
   iny
   dex
   bne remove_loop
done:
   rts
.endproc

.endif