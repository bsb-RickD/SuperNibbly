.ifndef UNITTESTING_INC
UNITTESTING_INC=1

.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.ifndef UT_INC
.include "lib/ut.inc"
.endif

.ifndef PRINT_INC
.include "lib/print.inc"
.endif

.import ut_pass_on_not_equal, ut_pass_on_equal
.import print_x_length, print_length_leading
.import print_dec_8, print_dec_16, print_hex
.import str_ut_welcome
.import compare_memory

.endif