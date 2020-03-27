all:
	cc65 -t none -O --cpu 65c02 main.c
	ca65 --cpu 65c02 main.s
	ca65 --cpu 65c02 puts.s
	ca65 --cpu 65c02 init.s
	ld65 -C k64.cfg -m main.map -o hello.raw puts.o main.o init.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

lib:
	ca65 crt0.s
	ar65 a k64.lib crt0.o

clean:
	rm -f *.o *.bin *.raw main.s main.map
