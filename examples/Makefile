hello:
	ca65 -I ../ hello.s
	ld65 -C examples.cfg -o hello.raw hello.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

ascii:
	ca65 -I ../ ascii.s
	ld65 -C examples.cfg -o ascii.raw ascii.o
	printf "\x00\x10" | cat - ascii.raw > ascii.bin

chess:
	ca65 -I ../ chess.s
	ld65 -C examples.cfg -o chess.raw chess.o
	printf "\x00\x10" | cat - chess.raw > chess.bin

break:
	ca65 -I ../ break.s
	ld65 -C examples.cfg -o break.raw break.o
	printf "\x00\x10" | cat - break.raw > break.bin

clock:
	ca65 -I ../ clock.s
	ld65 -C examples.cfg -o clock.raw clock.o
	printf "\x00\x10" | cat - clock.raw > clock.bin

via_test:
	ca65 -I ../ via_test.s
	ld65 -C examples.cfg -o via_test.raw via_test.o
	printf "\x00\x10" | cat - via_test.raw > via_test.bin

sound:
	ca65 -I ../ sound.s
	ld65 -C examples.cfg -o sound.raw sound.o
	printf "\x00\x10" | cat - sound.raw > sound.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
