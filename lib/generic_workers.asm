.ifndef GENERIC_WORKERS_ASM
GENERIC_WORKERS_ASM = 1

.ifndef RANDOM_ASM
.include "random.asm"
.endif

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


; init_r_range structure
;
; word range start        ; offset 0  
; word range end         ; offset 2
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