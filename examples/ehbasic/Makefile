all:
	ca65 -g --feature labels_without_colons -o basic.o min_mon.asm
	ld65 -C basic.cfg -m basic.map -o basic.raw basic.o
	printf "\x00\x10" | cat - basic.raw > basic.bin
