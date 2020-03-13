hello:
	ca65 -I ../ hello.s
	ld65 -C examples.cfg -o hello.raw hello.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

ascii:
	ca65 -I ../ ascii.s
	ld65 -C examples.cfg -o ascii.raw ascii.o
	printf "\x00\x10" | cat - ascii.raw > ascii.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
