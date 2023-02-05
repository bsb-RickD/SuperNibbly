.ifndef GENERIC_WORKERS_ASM
GENERIC_WORKERS_ASM = 1

.ifndef RANDOM_ASM
.include "random.asm"
.endif

.macro make_sequence w0, t0, w1, t1, w2, t2, w3, t3, w4, t4, w5, t5, w6, t6, w7, t7, w8, t8, w9, t9
.assert ((.paramcount .mod 2) = 0), error, "Params to make_squence need to come in pairs - always one worker and one this pointer together"
.byte .paramcount / 2   ; count of elements
.byte 0                 ; current element of sequence
.ifnblank w0
.ifnblank t0
.word w0,t0
.endif
.ifnblank w1
.ifnblank t1
.word w1,t1
.endif
.ifnblank w2
.ifnblank t2
.word w2,t2
.endif
.ifnblank w3
.ifnblank t3
.word w3,t3
.endif
.ifnblank w4
.ifnblank t4
.word w4,t4
.endif
.ifnblank w5
.ifnblank t5
.word w5,t5
.endif
.ifnblank w6
.ifnblank t6
.word w6,t6
.endif
.ifnblank w7
.ifnblank t7
.word w7,t7
.endif
.ifnblank w8
.ifnblank t8
.word w8,t8
.endif
.ifnblank w9
.ifnblank t9
.word w9,t9
.endif
.endif
.endif
.endif
.endif
.endif
.endif
.endif
.endif
.endif
.endif
.endmacro

; sequence structure
;
; byte count   ; offset 0 - how many elements are in the sequence
; byte current ; offset 1 - which element is currently being executed?
;
; -- repeat count times --- the list of workers
; word worker  ; offset 2,6,10,14, ...
; word thisptr ; offset 4,8,12,16, ...
;
.proc worker_sequence
   ldy #1
   lda (R15),y                      ; get current
   cmp (R15)                        ; is current == count?
   beq re_init
   asln 2                           ; current * 4
   adc #2                           ; (current * 4)+2
   tay                              ; y now points to the worker
   PushW R15                        ; save our this
   ThisLoadW R15, jsr_to_patch+1    ; get address and fill in the jsr destination
   ThisLoadW R15, R15, -            ; load this pointer into R15
jsr_to_patch:   
   jsr $CA11                        ; dispatch the call
   PopW R15                         ; bring this back
   bcc done                         ; work not complete - just return here next call
   ldy #1
   lda (R15),y                      ; get current
   inc                              ; advance..
   sta (R15),y                      ; ..and store
   cmp (R15)                        ; is current == count? beauty of it: the carry flag is set correctly by this operation
done:   
   rts
re_init:
   lda #0                           ; initialize current..
   sta (R15),y                      ; ..to zero, and store it
   bra worker_sequence+2            ; start over
.endproc

; range 8 structure
;
; byte start   ; offset 0
; byte end     ; offset end

; decrement start until its equal to end
;
; R15 points to the range8 structure
.proc worker_decrement_8
   lda (R15)
   dec
   sta (R15)               ; store decremented value
   ldy #1
   lda (R15),y
   cmp (R15)               ; this sets the carry flag like we need it
   rts
.endproc


; range 16 structure
;
; word start   ; offset 0
; word end     ; offset 2


; decrement start until its equal to end
;
; R15 points to the range8 structure
.proc worker_decrement_16
   lda (R15)
   sec
   sbc #1
   sta (R15)
   sta cmp_lo+1
   ldy #1
   lda (R15),y
   sbc #0
   sta (R15),y             ; store decremented value  (a = highbyte)
   sta cmp_hi+1

   ldy #3
   lda (R15),y
cmp_hi:   
   cmp #00                 ; this sets the carry flag like we need it
   bcc done
   dey
   lda (R15),y
cmp_lo:
   cmp #00                 ; this sets the carry flag like we need it
done:   
   rts
.endproc



; init_r_range structure
;
; word range start         ; offset 0  
; word range end           ; offset 2
; byte chunksize           ; offset 3 - should be a power of 2 (or 0 for all) 
; word pointer             ; offset 4 - where to initialize the random range object to


; init random_range
;
; R15 points to the init_r_range structure
.proc worker_initialize_random_range
   ThisLoadW R15,R0,0
   ThisLoadW R15,R1
   ThisLoadB R15,R2
   ThisLoadW R15,R15,-
   jsr rand_range_init
   sec                     ; one shot, so set carry
   rts
.endproc


; generate_random structure
;
; word points to destination              ; offset 0 - here the random number is stored
; word points to random range object      ; offset 2 - points to the generator, expected to be initialized 

; generate a random 16 bit number
;
; R15 points to the generate_random structure
.proc worker_generate_random
   ThisLoadW R15, R13, 0
   ThisLoadW R15, R15,-
   jsr rand_range          ; get the number in r0
   ThisStoreW R13,R0,0     ; write it to the destination
   sec                     ; one shot, so set carry
   rts
.endproc

.endif