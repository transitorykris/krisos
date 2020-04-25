all: hello ascii break via_test
.PHONY: all

.PHONY: hello
hello:
	ca65 -I ../../stdlib hello.s
	ld65 -C examples.cfg -o hello.raw hello.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

.PHONY: ascii
ascii:
	ca65 -I ../../stdlib ascii.s
	ld65 -C examples.cfg -o ascii.raw ascii.o
	printf "\x00\x10" | cat - ascii.raw > ascii.bin

.PHONY: break
break:
	ca65 -I ../../stdlib break.s
	ld65 -C examples.cfg -o break.raw break.o
	printf "\x00\x10" | cat - break.raw > break.bin

.PHONY: via_test
via_test:
	ca65 -I ../../stdlib via_test.s
	ld65 -C examples.cfg -o via_test.raw via_test.o
	printf "\x00\x10" | cat - via_test.raw > via_test.bin

.PHONY: char
char:
	ca65 -I ../../stdlib char.s
	ld65 -C examples.cfg -o char.raw char.o
	printf "\x00\x10" | cat - char.raw > char.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
