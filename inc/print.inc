.ifndef PRINT_INC
PRINT_INC = 1

.macro print_push_state
   pha
   phx
   phy
   PushW R11
.endmacro

.macro print_pop_state
   PopW R11
   ply
   plx
   pla
.endmacro

; print a string + extras that were passed as parameter: prints "erik was here",CHR_NL,"and he rocks"
.macro prints str, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10
   .local @msg
   .local @end
   print_push_state
   LoadW R11, @msg
   ldx #(@end-@msg)
   jsr print_x_length
   bra @end
@msg:
.byte str
.ifnblank extra1
.byte extra1
.ifnblank extra2
.byte extra2
.ifnblank extra3
.byte extra3
.ifnblank extra4
.byte extra4
.ifnblank extra5
.byte extra5
.ifnblank extra6
.byte extra6
.ifnblank extra7
.byte extra7
.ifnblank extra8
.byte extra8
.ifnblank extra9
.byte extra9
.ifnblank extra10
.byte extra10
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
@end:
   print_pop_state
.endmacro

; print as many newlines as specified by count
; (specifying no count will yield one newline)
.macro newline Count
   .if .paramcount = 0
      newline 1
   .elseif (Count) = 0
      .exitmacro
   .else
      lda #CHR_NL
      jsr KRNL_CHROUT
      newline Count-1
   .endif
.endmacro

; print a string at addr that has a leading length
.macro printl addr
   print_push_state
   LoadW R11, addr
   jsr print_length_leading
   print_pop_state
.endmacro

; print a string at addr that is zero terminated
.macro printz addr
   print_push_state
   LoadW R11, addr
   jsr print_zero_terminated
   print_pop_state
.endmacro


.macro print_dec number
   .if .paramcount = 1
      ; param passed, so load a
      .if (.match (.left (1,{number}),#))
         ; immediate mode
         lda #(.right (.tcount ({number})-1, {number}))
      .else
         ; assume absolute oder zero page
         lda number
      .endif
   .endif
   jsr print_dec_8
.endmacro

.endif