.ifndef TRAVEL_WORKERS_ASM
TRAVEL_WORKERS_ASM = 1

.ifndef COMMIN_INC
.include "inc/common.inc"
.endif

.ifndef TRAVEL_DEFS_INC
.include "travel/travel_defs.inc"
.endif

.export travel_left

.import show_sprite

; R15 pointer to a moving sprite
.proc travel_left   
   ThisLoadW R15,R0,0,-    ; R0 is now the pos stored at R15
   lda R0L
   ldy #2
   sec
   sbc (R15),y             ; subtract decrement
   sta R0L                 ; lo-word done
   lda R0H
   sbc #0
   sta R0H                 ; high-word done

   ; have we left the frame entirely?
   CmpBI R0H, .hibyte(neg_word((32-11)*TRAVEL_SUBPIXEL))
   bne store_updated_value ; high bytes don't macht - just carry on
   CmpBI R0L, .lobyte(neg_word((32-11)*TRAVEL_SUBPIXEL))
   ble wrap_around         ; yes, wrap around
store_updated_value:   
   ThisStoreW R15, R0, 0,- ; store updated value in our structure
   AsrW R0,::TRAVEL_SP_SHIFT ; shift right and store the result
   ThisStoreW R15, R0, 4,- ; store as sprite pos
   AddVW 4,R15             ; advance the pointer to the sprite structure
   jsr show_sprite         ; show the sprite
   clc                     ; indicate we want to carry on 
   rts
wrap_around:
   ; ok, an absurd coincindence happened here: we need to add 128, because we need to add 4*32* = 128
   ; with the sub pixel resolution it becomes a multiple of 256, so we only need to increment the high word..
   ldy #3
   lda (R15),y             ; get increment
   add R0H                 ; add to high word
   sta R0H
   bra store_updated_value ; write it back..
.endproc

.endif