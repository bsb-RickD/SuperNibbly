.ifndef GENERIC_WORKERS_ASM
GENERIC_WORKERS_ASM = 1

.ifndef RANDOM_ASM
.include "lib/random.asm"
.endif

.ifndef VERA_ASM
.include "lib/vera.asm"
.endif

.ifndef PALETTEFADER_ASM
.include "lib/palettefader.asm"
.endif


.macro dw2_ w1,w2
.ifnblank w1
.ifnblank w2
.word w1,w2
.endif
.endif
.endmacro

.macro make_sequence w0,t0, w1,t1, w2,t2, w3,t3, w4,t4, w5,t5, w6,t6, w7,t7, w8,t8, w9,t9, wa,ta, wb,tb, wc,tc, wd,td, we,te, wf,tf
.assert ((.paramcount .mod 2) = 0), error, "Params to make_squence need to come in pairs - always one worker and one this pointer together"
.byte .paramcount / 2   ; count of elements
.byte 0                 ; current element of sequence
dw2_ w0,t0 
dw2_ w1,t1
dw2_ w2,t2
dw2_ w3,t3
dw2_ w4,t4
dw2_ w5,t5
dw2_ w6,t6
dw2_ w7,t7
dw2_ w8,t8
dw2_ w9,t9
dw2_ wa,ta
dw2_ wb,tb
dw2_ wc,tc
dw2_ wd,td
dw2_ we,te
dw2_ wf,tf
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

.macro make_parallel w0,t0, w1,t1, w2,t2, w3,t3, w4,t4, w5,t5, w6,t6, w7,t7, w8,t8, w9,t9, wa,ta, wb,tb, wc,tc, wd,td, we,te, wf,tf
.assert ((.paramcount .mod 2) = 0), error, "Params to make_squence need to come in pairs - always one worker and one this pointer together"
.byte .paramcount / 2         ; count of elements
.res (.paramcount / 2)+1, 0   ; list of active elements, declared as empty   
dw2_ w0,t0 
dw2_ w1,t1
dw2_ w2,t2
dw2_ w3,t3
dw2_ w4,t4
dw2_ w5,t5
dw2_ w6,t6
dw2_ w7,t7
dw2_ w8,t8
dw2_ w9,t9
dw2_ wa,ta
dw2_ wb,tb
dw2_ wc,tc
dw2_ wd,td
dw2_ we,te
dw2_ wf,tf
.endmacro

; if semaphore at R15 is zero, this signals done
.proc worker_wait_semaphore
   lda (R15)
   bne wait
   sec
   rts
wait:
   clc
   rts   
.endproc

; decrement the semaphore, one shot
.proc worker_signal_semaphore
   lda (R15)
   dec
   sta (R15)
   sec
   rts
.endproc

; decompress to vram structure
;
; .word vram_lm         ; offset 0 - low and med byte of address
; .byte vram_h          ; offset 1 - high byte of address
; .word source          ; offset 3 - ptr to compressed memory
; .byte bank            ; offset 5 - bank of the source memory
; .word store_address   ; offset 6 - ptr to memory to receive the address of the next byte in vram after decoding
;
.proc worker_decompress_to_vram
   LoadB VERA_ctrl, VERA_port_0     ; data port 0
   ThisLoadW R15, VERA_addr_low, 0  ; 1st word of address
   lda (R15),y
   and #01
   ora #(VERA_increment_1 + VERA_increment_addresses)     
   sta VERA_addr_high               ; last part of address + direction and increment

   iny
   ThisLoadW R15, R0                ; compressed data to R0 (source)
   ThisLoadB R15, BANK              ; set bank byte
   LoadW R1, VERA_data0             ; vera data #0 to R1 (destination)
   jsr memory_decompress

   LoadB VERA_ctrl, VERA_port_0     ; data port 0
   ThisLoadW R15,R14,6,-            ; R14 points to output address
   ldy #0
copy_address:   
   lda VERA_addr_low,y              ; copy byte ... 
   sta (R14),y                      ; .. by byte ..
   iny
   cpy #3                           ; .. until ...
   bne copy_address                 ; .. we're done

   sec                              ; set carry flag to indicate that the next worker task should start
   rts      
.endproc



; palette fader structure
;
; .word palfade         ; offset 0 - ptr to palfade structure
; .word buffer          ; offset 2 - ptr to fade buffer
; .byte fadedirectrion  ; offset 4 - 0 to fade to target, 1 to fade from target color
; .word mapping         ; offset 5 - ptr to palette mapping
;
.proc worker_palette_fade
   MoveW R15,R14                 ; keep this pointer around

   ThisLoadW R14,R15,0           ; bring in this pointer for palfade object
   ThisLoadW R14,R0,-            ; bring in pointer for the fade buffer   
   ldy #5
   lda (R15),y
   bne fade_further              ; are we here the first time?

   ldy #4
   lda (R14),y                   ; load the fade direction
   ror                           ; shift the direction into the carry flag - to determine the direction
   jsr palettefader_start_fade   ; initialize pal fade
   bra write_the_pal

fade_further:
   jsr palettefader_step_fade     ; second time round, fade..

write_the_pal:
   ThisLoadW R14,R1,5            ; bring in pointer for the mapping
   lda #0
   jsr write_to_palette_mapped

   ldy #5
   lda (R15),y
   beq complete                  ; are we done?

   clc                           ; fade not done, carry on
   rts                  
complete:
   sec                           ; indicate that we're done
   rts
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