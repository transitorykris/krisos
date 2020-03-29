all: sound
.PHONY: all

.PHONY: sound
sound:
	ca65 -I ../ sound.s
	ld65 -C examples.cfg -o sound.raw sound.o
	printf "\x00\x10" | cat - sound.raw > sound.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
