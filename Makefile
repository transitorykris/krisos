all:
	ca65 via.s
	ca65 sound.s
	ca65 lcd.s
	ca65 acia.s
	ca65 binhex.s
	ca65 stdlib.s
	ca65 term.s
	ca65 command.s
	ca65 xmodem.s
	ca65 kernel.s
	ld65 -C krisos.cfg \
		-m krisos.map -v \
		-o kernel.bin via.o sound.o lcd.o \
		acia.o binhex.o stdlib.o term.o command.o xmodem.o \
		kernel.o

clean:
	rm *.o

burn:
	minipro -p AT28C256 -w kernel.bin

terminal:
	picocom -b 19200 --send-cmd 'sz -X' /dev/cu.usbserial-DN05JN76
