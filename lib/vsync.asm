.ifndef VSYNC_ASM
VSYNC_ASM = 1

.ifndef IRQ_ASM
.include "lib/irq.asm"
.endif

; globals
vsync_count:      .word 0

VSYNC_worker_ptr = ZEROPAGE_SCRATCH

; use this macro to install code to be executed in the vsync
; at the end of the routine do a "jmp vsync_irq_exit"
.macro set_vsync_worker ptr
   LoadW VSYNC_worker_ptr, ptr
.endmacro


; use this macro to remove vsync callbacks again
;
.macro clear_vsync_worker
   set_vsync_worker vsync_irq_exit
.endmacro


; install vsyc interrupt and and optional worker
;
.macro init_vsync_irq worker
   .if .paramcount = 1
      set_vsync_worker worker
   .else
      ; clear the worker
      clear_vsync_worker
   .endif
   ; save irq, and install our vsync_irq
   LoadW R0, vsync_irq
   jsr init_irq
.endmacro

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


; remove vsync interrupt again
;
.macro clear_vsync_irq
   jsr reset_irq
.endmacro

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
   beq vsync_irq_exit                  ; bit 1 not set - no vsync, bit 2 not set - no hsync
   and #2                              ; check vsync bit
   bne hsync_irq_pre                   ; bit 2 set - go to hsync

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
   set_vera_address $1FA00, VERA_port_1; vera data port 0 - reset to pal 0
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
   jmp (default_irq)                   ; for vsyncs, jump to the default handler, it does all the cleanup, keeps os happy, etc.
.endif



hsync_irq_pre:
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
   cmp $FF
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
   lda #1
   sta VERA_ien                        ; disable h-sync, keep only v-sync   
leave:
   lda #2
   sta VERA_isr                        ; ack interrupt

   ; hsync exists directly, not going to default handler
   ply
   plx
   pla            ; restore regs
   rti            ; kansas goes bye-bye
.endproc   
