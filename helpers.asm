.ifndef HELPERS_INCLUDED

HELPERS_INCLUDED = 1

; expands to as many asl commands as specified by shift
.macro sal shift
   .if (shift) = 0
      .exitmacro
   .endif
   .assert ((shift) >= 1) && ((shift) < 8), error, "sal can only take 1 to 7 as parameter"
      sal ((shift)-1)
      asl
.endmacro   

; mob - move byte
.macro mob source,dest
   .if (.match (.left (1,{source}),#))
      ; immediate mode
      lda #(.right (.tcount ({source})-1, {source}))
      sta dest
   .else
      ; assume absolute oder zero page
      lda source
      sta dest
   .endif
.endmacro


; mow - move word
.macro mow source,dest
   .if (.match (.left (1,{source}),#))
      ; immediate mode
      lda #<(.right (.tcount ({source})-1, {source}))
      sta dest
      lda #>(.right (.tcount ({source})-1, {source}))
      sta dest+1
   .else
      ; assume absolute oder zero page
      lda source
      sta dest
      lda source+1
      sta dest+1
   .endif
.endmacro

; phw - push word
.macro phw word
   .if (.match (.left (1,{word}),#))
      ; immediate mode
      lda #<(.right (.tcount ({word})-1, {word}))
      sta dest
      lda #>(.right (.tcount ({word})-1, {word}))
      sta dest+1
   .else
      ; assume absolute oder zero page
      lda word
      pha
      lda word+1
      pha
   .endif
.endmacro

; plw - pull word
.macro plw word
   ; assume absolute oder zero page
   pla
   sta word+1
   pla 
   sta word
.endmacro

; inc word
.macro IncW addr
   .local @j
   inc addr
   bne @j
   inc addr+1
   @j:
.endmacro


.endif