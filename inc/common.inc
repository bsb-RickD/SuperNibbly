.ifndef COMMON_INC
COMMON_INC = 1

.feature c_comments
.linecont +

.ifndef REGS_INC
.include "regs.inc"
.endif

.ifndef KERNAL_INC
.include "kernal.inc"
.endif

.ifndef VERA_INC
.include "vera.inc"
.endif

.ifndef MAC_INC
.include "mac.inc"
.endif

.endif
