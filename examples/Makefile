all:
	ca65 -I ../ hello.s
	ld65 -C examples.cfg -o hello.raw hello.o
	printf "\x00\x10" | cat - hello.raw > hello.bin
