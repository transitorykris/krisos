all:
	ca65 kernel.s
	ca65 xmodem.s
	ld65 -C krisos.cfg -o kernel.bin kernel.o

burn:
	minipro -p AT28C256 -w kernel.bin
