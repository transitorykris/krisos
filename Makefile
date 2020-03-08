all:
	ca65 kernel.s
	ca65 acia.s
	ca65 xmodem.s
	ld65 -C krisos.cfg -o kernel.bin acia.o kernel.o

clean:
	rm *.o

burn:
	minipro -p AT28C256 -w kernel.bin
