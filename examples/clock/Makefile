all: clock
.PHONY: all

.PHONY: clock
clock:
	ca65 -I ../ clock.s
	ld65 -C examples.cfg -o clock.raw clock.o
	printf "\x00\x10" | cat - clock.raw > clock.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
