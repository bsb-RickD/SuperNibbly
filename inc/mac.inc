;----------------------------------------------------------------------
; Commander X16 KERNAL 16 Bit Macros
;----------------------------------------------------------------------
; (C)2020 Michael Steil, License: 2-clause BSD
; based on GEOS 64, edited by Maciej 'YTM/Alliance' Witkowiak
; Modified / extended by Erik 'Rick Dangerous/S!P' Pojar

.ifndef MAC_INC
MAC_INC = 1

; also bring in jeq, jne, jmi, jpl, jcs, jcc, jvs, jvc
.macpack longbranch



.macro LoadB dest, value
	.if .const(value) .and value=0
		stz dest
	.else
		lda #value
		sta dest
	.endif
.endmacro

.macro LoadW dest, value
	.if .const(value) .and .lobyte(value)=0
		stz dest
	.else
		lda #<(value)
		sta dest
	.endif
	.if .const(value) .and .hibyte(value)=0
		stz dest+1
	.else
		.if (.not .const(value)) .or (>(value))<>(<(value))
			lda #>(value)
		.endif
		sta dest+1
	.endif
.endmacro

.macro MoveB source, dest
	lda source
	sta dest
.endmacro

.macro MoveW source, dest
	MoveB source+0, dest+0
	MoveB source+1, dest+1
.endmacro

.macro add source, reg
	clc
.if .paramcount = 1
	adc source
.elseif	.paramcount = 2
	adc source,reg
.endif	
.endmacro

.macro AddB source, dest
	lda source
	add dest
	sta dest
.endmacro

.macro AddW source, dest
	AddB source+0, dest+0
	lda source+1
	adc dest+1
	sta dest+1
.endmacro

.macro AddVB value, dest
	lda dest
	clc
	adc #value
	sta dest
.endmacro

.macro AddVW value, dest
	.local j
	lda dest
	clc
	adc #<(value)
	sta dest
	.if (>(value))=0
		bcc j
		inc dest+1
		j:
	.else
		lda dest+1
		adc #>(value)
		sta dest+1
	.endif
.endmacro

.macro sub source
	sec
	sbc source
.endmacro

.macro SubB source, dest
	lda dest
	sub source
	sta dest
.endmacro

.macro SubW source, dest
	SubB source+0, dest+0
	lda dest+1
	sbc source+1
	sta dest+1
.endmacro

.macro SubVW value, dest
	.local j
	lda dest+0
	sec
	sbc #<(value)
	sta dest+0

	.if (>(value))=0
		bcs j
		dec dest+1
		j:
	.else
		lda dest+1
		sbc #>(value)
		sta dest+1
	.endif
.endmacro

.macro CmpB source, dest
	lda source
	cmp dest
.endmacro

.macro CmpBI source, immed
	lda source
	cmp #immed
.endmacro

.macro CmpW source, dest
	.local @j
	CmpB source+1, dest+1
	bne @j
	CmpB source+0, dest+0
@j:
.endmacro

.macro CmpWI source, immed
	.local @j
	CmpBI source+1, >(immed)
	bne @j
	CmpBI source+0, <(immed)
@j:
.endmacro

.macro PushB source
	lda source
	pha
.endmacro


; modified by Erik to include immediate #values
; source can be either a source or a #value 
.macro PushW source
.if (.match (.left (1, {source}), #))
  	; source is a #value
	PushB #<(.right (.tcount ({source})-1, {source}))
	PushB #>(.right (.tcount ({source})-1, {source}))
.else
  	; assume absolute or zero page for sorv
	PushB source+0
	PushB source+1
.endif

.endmacro

.macro PopB dest
	pla
	sta dest
.endmacro

.macro PopW dest
	PopB dest+1
	PopB dest+0
.endmacro

.macro smb bitN, dest
	pha
	smbf bitN, dest
	pla
.endmacro

.macro smbf bitN, dest
	lda #1 << bitN
	.ifp02
		ora dest
		sta dest
	.else
		tsb dest
	.endif
.endmacro

.macro rmb bitN, dest
	pha
	rmbf bitN, dest
	pla
.endmacro

.macro rmbf bitN, dest
	.ifp02
		lda #(1 << bitN) ^ $ff
		and dest
		sta dest
	.else
		lda #1 << bitN
		trb dest
	.endif
.endmacro

.macro bbs bitN, source, addr
	.local @j
	php
	pha
	lda source
	and #1 << bitN
	beq @j
	pla
	plp
	bra addr
@j:
	pla
	plp
.endmacro

.macro bbsf bitN, source, addr
	.if (bitN = 7)
		bit source
		bmi addr
	.else
		.if (bitN = 6)
			bit source
			bvs addr
		.else
			lda source
			and #1 << bitN
			bne addr
		.endif
	.endif
.endmacro

.macro bbr bitN, source, addr
	.local @j
	php
	pha
	lda source
	and #1 << bitN
	bne @j
	pla
	plp
	bra addr
@j:
	pla
	plp
.endmacro

.macro bbrf bitN, source, addr
	.if (bitN = 7)
		bit source
		bpl addr
	.else
		.if (bitN = 6)
			bit source
			bvc addr
		.else
			lda source
			and #1 << bitN
			beq addr
		.endif
	.endif
.endmacro

.macro addv value
	clc
	adc #value
.endmacro

.macro subv value
	sec
	sbc #value
.endmacro

.macro bnex addr
	txa
	bne addr
.endmacro

.macro beqx addr
	txa
	beq addr
.endmacro

.ifp02
	.macro bra addr
		jmp addr
	.endmacro
.endif

.macro IncW addr
	.local @j
	inc addr
	bne @j
	inc addr+1
	@j:
.endmacro

.macro DecW_ addr
	.local @j
	lda addr
	bne @j
	dec addr+1
@j:	dec addr
.endmacro

.macro DecW addr
	DecW_ addr
	lda addr
	ora addr+1
.endmacro

; ------------------------- Eriks additional macros starts here -------------------------

; branch greater equal
.macro  bge     Arg
        bcs     Arg
.endmacro

; branch less than
.macro  blt     Arg
        bcc     Arg
.endmacro

; branch greater than
.macro  bgt     Arg
        .local  L
        beq     L
        bcs     Arg
L:
.endmacro

; branch less equal
.macro  ble     Arg
        beq     Arg
        bcc     Arg
.endmacro

; arithmetic shift right
.macro  asr arg         ; Arithmetic shift right
.if .paramcount = 1
   lda arg
.endif
   cmp     #$80    ; Put bit 7 into carry
   ror             ; Rotate right with carry
.if .paramcount = 1
   sta arg
.endif

.endmacro

; arithmetic shift right of 16 bit word
.macro AsrW arg, shift
.if .blank(shift) .or ((shift) = 1)
   asr arg+1
   ror arg
.else
	.assert ((shift) >= 2) && ((shift) < 16), error, "shift for AsrW can only be 1 to 15"
	.if ((shift) = 2)
		lda arg+1
		cmp #$80
		ror
		ror arg
		cmp #$80
		ror 
		ror arg
		sta arg+1
	.else
		.local loop
		ldx #(shift)
		lda arg+1
loop:
		cmp #$80
		ror
		ror arg
		dex
		bne loop
		sta arg+1		
	.endif
.endif   
.endmacro   


; expands to as many asl commands as specified by shift
.macro asln shift
   .if (shift) = 0
      .exitmacro
   .endif
   .assert ((shift) >= 1) && ((shift) < 8), error, "asln can only take 1 to 7 as parameter"
      asln ((shift)-1)
      asl
.endmacro

; expands to as many ror commands as specified by shift
.macro rorn shift
   .if (shift) = 0
      .exitmacro
   .endif
   .assert ((shift) >= 1) && ((shift) < 8), error, "rorn can only take 1 to 7 as parameter"
      rorn ((shift)-1)
      ror
.endmacro

; lxy - load word to x (lobyte) , y (hibyte)
.macro lxy source
   .if (.match (.left (1,{source}),#))
      ; immediate mode
      ldx #<(.right (.tcount ({source})-1, {source}))
      ldy #>(.right (.tcount ({source})-1, {source}))
   .else
      ; assume absolute oder zero page
      ldx source
      ldy source+1
   .endif
.endmacro


; helper macros for the ThisLoad / ThisStore macros below
;
; macro trickery to enable optional y init offset and optional "-" paramter to skip iny at end
.macro _load_y_conditionally offset, optional
	.if .paramcount > 0
		.if (.not .blank(offset)) .and (.not .xmatch({offset}, -))
			ldy #offset
		.endif

		; check that no other character than - was appended
		.if (.not .blank(offset)) .and (.not .blank(optional))
			.assert .xmatch({optional}, -), error, "optional param can only be -"
		.endif
	.endif
.endmacro

; helper macros for the ThisLoad / ThisStore macros below
;
; macro trickery to enable optional y init offset and optional "-" paramter to skip iny at end
.macro _inc_y_conditionally offset, optional
	.if .blank(offset) .and .blank(optional)
		; both blank: increment
		iny
	.elseif .blank(optional) .and (.not .xmatch({offset}, -))
		; only offset and it's not -: increment
		iny
	.endif
.endmacro


; load a byte from (this),y and copy to dest
;
; offset is optional, if given, will initialize y to the offset
; y is incremeted 
;
.macro ThisLoadB this, dest, offset, optional
	_load_y_conditionally offset, optional
	
	lda (this),y
	sta dest
	
	_inc_y_conditionally offset, optional
.endmacro

; store a byte from source to (this),y
;
; offset is optional, if given, will initialize y to the offset
; y is incremeted 
;
.macro ThisStoreB this, source, offset, optional
	_load_y_conditionally offset, optional	

	lda source
	sta (this),y
	
	_inc_y_conditionally offset, optional
.endmacro



; load a word from (this),y and copy to dest
;
; offset is optional, if given, will initialize y to the offset
; y is incremeted 
;
.macro ThisLoadW this, dest, offset, optional
	_load_y_conditionally offset, optional	

.if .not .xmatch({this}, {dest})  
	; regular case
	ThisLoadB this, dest+0
	ThisLoadB this, dest+1, -
.else
	; special case, we want to load a this pointer from this pointer
	; e.g. read a pointer from (R15),y and copy it into R15
	lda (this),y
	tax
	iny
	ThisLoadB this, dest+1, -
	stx dest
.endif

	_inc_y_conditionally offset, optional
.endmacro

; store a word from source to (this),y
;
; offset is optional, if given, will initialize y to the offset
; y is incremeted 
;
.macro ThisStoreW this, source, offset, optional
	_load_y_conditionally offset, optional
	
	ThisStoreB this, source+0
	ThisStoreB this, source+1, -

	_inc_y_conditionally offset, optional
.endmacro



; modified by Erik to include immediate #values
;
; dest = source1 + sorv
; sorv can be either a source or a #value 
.macro AddW3 source, sorv, dest
.if (.match (.left (1, {sorv}), #))
  	; sorv is a value
	lda source
	clc
	adc #<(.right (.tcount ({sorv})-1, {sorv}))
	sta dest
	lda source+1
	adc #>(.right (.tcount ({sorv})-1, {sorv}))
	sta dest+1
.else
  	; assume absolute or zero page for sorv
	lda source
	clc
	adc sorv
	sta dest
	lda source+1
	adc sorv+1
	sta dest+1
.endif
.endmacro

; dest = source - sorv
; sorv can be either a source or a #value 
.macro SubW3 source, sorv, dest
.if (.match (.left (1, {sorv}), #))
  	; sorv is a value
	lda source
	sec
	sbc #<(.right (.tcount ({sorv})-1, {sorv}))
	sta dest
	lda source+1
	sbc #>(.right (.tcount ({sorv})-1, {sorv}))
	sta dest+1
.else
  	; assume absolute or zero page for sorv
	lda source
	sec
	sbc sorv
	sta dest
	lda source+1
	sbc sorv+1
	sta dest+1
.endif
.endmacro

; 8 bit not
; 
; if no source is specified - not a
.macro not source
.if .paramcount = 1
	lda source
.endif
	eor #$FF
.if .paramcount = 1
	sta source
.endif
.endmacro

; 8 bit negate + add
;
; a = value - a
;
; so to negate a, use "nad 0"
.macro nad Value
	not
	sec
	adc #Value
.endmacro

.define neg_word(n) (($FFFF-n)+1)
.define neg_byte(n) (($FF-n)+1)

; string with leading length
.macro Lstr string, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10
.local start, end
.byte end-start
start:
.byte string
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
end:
.endmacro


.endif