.ifndef WORK_QUEUE_INC
WORK_QUEUE_INC = 1


.macro commands_to_add base, p1, p2, p3, p4
.local OFFSET
OFFSET = ((base-function_ptrs)/8)
.if .paramcount = 0
   .byte 0,0,0,0
.elseif .paramcount = 1
   .error "you need to specify a base ptr"
.elseif .paramcount = 2
   .byte OFFSET+p1,0,0,0
.elseif .paramcount = 3
   .byte OFFSET+p1,OFFSET+p2,0,0
.elseif .paramcount = 4
   .byte OFFSET+p1,OFFSET+p2,OFFSET+p3,0
.elseif .paramcount = 5
   .byte OFFSET+p1,OFFSET+p2,OFFSET+p3,OFFSET+p4
.endif
.if (.paramcount > 1) .and (base < $80D)
   .error "base ptr is very suspicious - did you forget to specify one?"
.endif   
.endmacro 

.define no_commands_to_add commands_to_add


.endif