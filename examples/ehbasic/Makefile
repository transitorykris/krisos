all: basic
.PHONY: all

.PHONY: basic
basic:
	ca65 -I ../../stdlib basic.s
	ld65 -C basic.cfg -o basic.raw basic.o
	printf "\x00\x10" | cat - basic.raw > basic.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
