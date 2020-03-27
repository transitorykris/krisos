all:
	cc65 -t none -O --cpu 65c02 main.c
	ca65 --cpu 65c02 main.s
	ca65 --cpu 65c02 puts.s
	ld65 -C sbc.cfg -m main.map -o hello.bin puts.o main.o sbc.lib
	printf "\x00\x10" | cat - a.out > a.bin

lib:
	ca65 crt0.s
	ar65 a sbc.lib crt0.o

clean:
	rm -f *.o *.bin main.s main.map