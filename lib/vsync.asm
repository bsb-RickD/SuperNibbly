.ifndef VSYNC_ASM
VSYNC_ASM = 1

.segment "CODE"

.ifndef VERA_INC
.include "inc/vera.inc"
.endif

.ifndef VSYNC_INC
.include "inc/vsync.inc"
.endif

.import default_irq

.export vsync_irq, vsync_count, wait_for_vsync, vsync_irq_exit

; globals
vsync_count:      .word 0

; wait for next vsync (or return immediately if one or multiple vsyncs have occured in the meantime)
; vsync count is zero afterwards
; 
.proc wait_for_vsync
   lda vsync_count
   beq wait_irq          ; vsync_count still zero? must have been some other IRQ
   stz vsync_count
   rts
 wait_irq:
   wai
   bra wait_for_vsync
.endproc

copper_list_enabled:
.byte 0

copper_list_start:            ; pointer to begin of list
.word 0

copper_ptr:                   ; current ptr - gets initialized to copper_list_start in the vsync and increments from there
.word 0



; the actual vsync routine
;
; increases the vsync count
;
.proc vsync_irq
   sei                                 ; disable interrupts
   lda VERA_isr
   and #3                              ; check vsync, hsync bit
   beq direct_irq_exit                 ; bit 1 not set - no vsync, bit 2 not set - no hsync, just leave
   and #2                              ; check hsync bit
   bne hsync_irq                       ; bit 2 set - go to hsync

   ; check if we have a copper_list
   lda copper_list_enabled
   beq no_copper_list_or_init_done   
init_copper_list:   
   PushW R0
   MoveW copper_list_start, R0
   ldy #0
   lda (R0),y                          ; line to start with
   sta VERA_irqline_low                ; store it
   iny 
   lda (R0),y                          ; get high 
   beq hi_byte_empty
   cmp $FF
   beq empty_list
   lda #$80
hi_byte_empty:
   ora #3
   sta VERA_ien                        ; enable v- and h-sync
   iny
   lda (R0),y                          ; color
   sta hsync_irq+1
   iny
   lda (R0),y                          ; color
   sta hsync_irq+6
   AddW3 R0, #4, copper_ptr            ; set up ptr
   set_vera_address $1FA00, VERA_port_1; vera data port 1 - reset to pal 0
   stz VERA_ctrl
empty_list:   
   PopW R0

no_copper_list_or_init_done:
   ; we have a vsync - increase the vsync_count
   inc vsync_count
   bne custom_code
   inc vsync_count+1                   ; overflow into second byte
   ; here we jump to the custom code
custom_code:   
   jmp (VSYNC_worker_ptr)
.endproc   

; jump here at the end of your custom irq code
;
vsync_irq_exit:  
   lda copper_list_enabled
   bne direct_vsync_exit               ; if we have a copper list, con't do the default irq handler - we'll do it at the end of the copper list
   jmp (default_irq)                   ; for vsyncs, jump to the default handler, it does all the cleanup, keeps os happy, etc.
direct_vsync_exit:
   lda #1
   sta VERA_isr                        ; ack vsync, intentional fall through to direct_irq_exit
.endif

.proc direct_irq_exit
   ; hsync exists directly, not going to default handler
   ply
   plx
   pla            ; restore regs
   rti            ; kansas goes bye-bye
.endproc   

.proc hsync_irq
   ; write the color
   lda #0
   sta VERA_data1
   lda #0
   sta VERA_data1

   ; maintenance code to set up the next line..
   PushW R0
   MoveW copper_ptr, R0
   ldy #0
   lda (R0),y                          ; line to start with
   sta VERA_irqline_low                ; store it
   iny 
   lda (R0),y                          ; get high byte of address
   beq hi_byte_empty
   cmp #$FF
   beq list_complete
   lda #$80
hi_byte_empty:
   ora #3
   sta VERA_ien                        ; enable v- and h-sync
   iny
   lda (R0),y                          ; color
   sta hsync_irq+1
   iny
   lda (R0),y                          ; color
   sta hsync_irq+6
   AddW3 R0, #4, copper_ptr            ; set up ptr
   PopW R0
   lda #1
   sta VERA_ctrl
   stz VERA_addr_low                   ; vera data port 1 - reset to pal 0
   stz VERA_ctrl
   bra leave
list_complete:
   PopW R0
   lda #1
   sta VERA_ien                        ; disable h-sync, keep only v-sync   
   lda #2
   sta VERA_isr                        ; ack interrupt
   ; for a copper list, the default irq is postponed until afther the copper list.. this is now the case, so jump to default handler and keep os happy...
   jmp (default_irq)   
leave:
   lda #2
   sta VERA_isr                        ; ack interrupt
   bra direct_irq_exit
.endproc