.ifndef COMMON_INC
COMMON_INC = 1

.feature c_comments
.linecont +

.ifndef REGS_INC
.include "inc/regs.inc"
.endif

.ifndef KERNAL_INC
.include "inc/kernal.inc"
.endif

.ifndef VERA_INC
.include "inc/vera.inc"
.endif

.ifndef MAC_INC
.include "inc/mac.inc"
.endif

.endif
