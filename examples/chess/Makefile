all: chess
.PHONY: all

.PHONY: chess
chess:
	ca65 -I ../ chess.s
	ld65 -C examples.cfg -o chess.raw chess.o
	printf "\x00\x10" | cat - chess.raw > chess.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
