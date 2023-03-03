.ifndef GENERIC_WORKERS_INC
GENERIC_WORKERS_INC = 1


.ifndef COMMON_INC
.include "inc/common.inc"
.endif

.macro dw2_ w1,w2
.ifnblank w1
.ifnblank w2
.word w1,w2
.endif
.endif
.endmacro

.macro make_sequence w0,t0, w1,t1, w2,t2, w3,t3, w4,t4, w5,t5, w6,t6, w7,t7, w8,t8, w9,t9, wa,ta, wb,tb, wc,tc, wd,td, we,te, wf,tf
.assert ((.paramcount .mod 2) = 0), error, "Params to make_squence need to come in pairs - always one worker and one this pointer together"
.byte .paramcount / 2   ; count of elements
.byte 0                 ; current element of sequence
dw2_ w0,t0 
dw2_ w1,t1
dw2_ w2,t2
dw2_ w3,t3
dw2_ w4,t4
dw2_ w5,t5
dw2_ w6,t6
dw2_ w7,t7
dw2_ w8,t8
dw2_ w9,t9
dw2_ wa,ta
dw2_ wb,tb
dw2_ wc,tc
dw2_ wd,td
dw2_ we,te
dw2_ wf,tf
.endmacro

.macro make_parallel w0,t0, w1,t1, w2,t2, w3,t3, w4,t4, w5,t5, w6,t6, w7,t7, w8,t8, w9,t9, wa,ta, wb,tb, wc,tc, wd,td, we,te, wf,tf
.assert ((.paramcount .mod 2) = 0), error, "Params to make_squence need to come in pairs - always one worker and one this pointer together"
.byte .paramcount / 2         ; count of elements
.res (.paramcount / 2)+1, 0   ; list of active elements, declared as empty   
dw2_ w0,t0 
dw2_ w1,t1
dw2_ w2,t2
dw2_ w3,t3
dw2_ w4,t4
dw2_ w5,t5
dw2_ w6,t6
dw2_ w7,t7
dw2_ w8,t8
dw2_ w9,t9
dw2_ wa,ta
dw2_ wb,tb
dw2_ wc,tc
dw2_ wd,td
dw2_ we,te
dw2_ wf,tf
.endmacro

.endif 