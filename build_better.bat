ca65 -t cx16 -I . -l lib/bin/math.list lib/math.asm -o lib/bin/math.o
ca65 -t cx16 -I . -l lib/bin/print.list lib/print.asm -o lib/bin/print.o
ca65 -t cx16 -I . -l lib/bin/ut.list lib/ut.asm -o lib/bin/ut.o
cl65 -t cx16 --asm-include-dir . --asm-args -U -m bla.map -o bla.prg -l bla.list unittests/testmath.asm lib/bin/math.o lib/bin/print.o lib/bin/ut.o

