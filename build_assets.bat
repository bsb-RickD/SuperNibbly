copy /b ..\screen.bin+..\tiles.bin+..\sprites.bin intro_data.raw
lzsa -r -f2 intro_data.raw intro_data.bin
del intro_data.raw
copy ..\sprites.inc .
copy ..\palette.bin .
