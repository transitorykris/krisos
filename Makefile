all:
	ca65 acia.s
	ca65 binhex.s
	ca65 term.s
	ca65 xmodem.s
	ca65 kernel.s
	ld65 -C krisos.cfg -o kernel.bin acia.o binhex.o term.o xmodem.o kernel.o

clean:
	rm *.o

burn:
	minipro -p AT28C256 -w kernel.bin

terminal:
	picocom -b 19200 --send-cmd 'sz -X' /dev/cu.usbserial-DN05JN76
