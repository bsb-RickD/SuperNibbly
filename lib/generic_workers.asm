.ifndef GENERIC_WORKERS_ASM
GENERIC_WORKERS_ASM = 1

.segment "CODE"

.ifndef GENERIC_WORKERS_INC
.include "inc/generic_workers.inc"
.endif

.import rand_range, rand_range_init
.import write_to_palette_mapped, palettefader_start_fade, palettefader_step_fade
.import memory_decompress
.import array_remove 

.export worker_parallel, worker_parallel_reset, worker_sequence
.export worker_generate_random, worker_initialize_random_range
.export worker_decrement_16, worker_decrement_8


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
   jsr call_worker_at_r15_y         ; do the actuall call
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

;
; helper fuction for sequence and parallel to call the contained workers
;
.proc call_worker_at_r15_y
   PushW R15                        ; save our this
   ThisLoadW R15, R1                ; get address to R1 for indirect call
   ThisLoadW R15, R15, -            ; load this pointer into R15
   jsr jsr_indirect                 ; dispatch the call
   PopW R15                         ; bring this back
   rts
jsr_indirect:
   jmp (R1)   
.endproc

;
; reset a sequence or parallel object, so it can be re-started
;
worker_parallel_reset:
.proc worker_sequence_reset
   ldy #1
   lda #0
   sta (R15),y                     
   rts
.endproc

; parallel structure
;
; byte count      ; offset 0 - how many elements are to be executed in parallel?
; count+1 bytes   ; offset 1 - list of active elements
;
; -- repeat count times --- the list of workers
; word worker     ; offset count+2, count+6, count+10, count+14, ...
; word thisptr    ; offset count+4, count+8, count+12, count+16, ...
;
.proc worker_parallel
   ldy #1
   lda (R15),y                ; get number of current workers
   beq re_init                ; all empty? re-init!
   tax                        ; x = count
   lda (R15)                  ; get total count of workers
   add #2                     ; add the two extra bytes for list header and count 
   sta R0L                    ; this is our offset from R15 to where the worker pointers start
call_workers:
   iny                        ; advance to next index
   phy                        ; save index
   phx                        ; save count
   lda (R15),y                ; a = index of worker to call   
   sta R0H                    ; remember it for potential removal
   asl
   asl                        ; multiply by 4, clear carry
   adc R0L                    ; add offset
   tay                        ; y points to the worker in the array
   PushW R0                   ; remember our offset
   jsr call_worker_at_r15_y   ; call worker
   PopW R0                    ; restore it
   plx                        ; bring the index back, bring the count back
   ply                        ; we do this early because we need to manipulate x,y in case we remove from the list, while we iterate it
   bcc nothing_to_remove      ; worker not done, come back next time
   IncW R15                   ; advance R15 to point to list
   lda R0H                    ; index of element to remove (because work is complete)
   jsr array_remove           ; remove the worker index - this keeps x,y intact!
   DecW R15                   ; R15 is our this pointer again
   dey                        ; decrement the index - we just lost an element, and the list "scrolled" towards the index
nothing_to_remove:
   dex                        ; do the loop decrement..
   bne call_workers           ; .. and jump
list_completed:   

   ldy #1
   lda (R15),y                ; get number of workers
   bne work_left              ; not zero? there's still work
finished:
   sec                        ; signal all work is done
   rts
work_left:
   clc                        ; signal there is still work left
   rts   
;--------------------------------------------------------------------------------------------------------   
re_init:
   lda (R15)            ; load count
   beq finished         ; security measure - if the count is zero this is an empty parallel - just leave!
   sta (R15),y          ; store as list length
   tax                  ; x = count
   lda #0               ; start with zero
init_list:   
   iny
   sta (R15),y          ; store index
   inc                  ; increment index
   dex                  ; decrement count
   bne init_list
   bra worker_parallel  ; second time round, it will all work :-)
.endproc

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