.ifndef FUNCTION_PTRS_INC
FUNCTION_PTRS_INC = 1

function_ptrs:
.ifndef INTRO_FUNCTION_PTRS_INC
.include "intro/intro_function_ptrs.inc"
.endif
.ifndef TRAVEL_FUNCTION_PTRS_INC
.include "travel/travel_function_ptrs.inc"
.endif

.endif