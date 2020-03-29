all:
	cc65 -t none -O --cpu 65c02 main.c
	ca65 main.s
	ca65 puts.s
	ca65 putchar.s
	ca65 getchar.s
	ca65 crt0.s
	ar65 a none.lib crt0.o
	ld65 -C none.cfg -m main.map -o hello.raw \
		puts.o putchar.o getchar.o main.o none.lib
	printf "\x00\x10" | cat - hello.raw > hello.bin

clean:
	rm -f *.o *.bin *.raw main.s main.map
