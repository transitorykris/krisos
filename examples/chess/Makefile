all: chess
.PHONY: all

.PHONY: chess
chess:
	ca65 -I ../ chess.s
	ld65 -C examples.cfg -o chess.raw chess.o
	printf "\x00\x10" | cat - chess.raw > chess.bin

chess2:
	ca65 -I ../ chess2.s
	ld65 -C examples.cfg -o chess2.raw chess2.o
	printf "\x00\x10" | cat - chess2.raw > chess2.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
