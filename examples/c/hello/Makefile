all:
	cc65 -t none -O --cpu 65c02 main.c
	ca65 main.s
	ca65 puts.s
	ca65 init.s
	ld65 -C k64.cfg -m main.map -o hello.raw puts.o main.o init.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

clean:
	rm -f *.o *.bin *.raw main.s main.map
