CA = ca65
CFLAGS =
LD = ld65
LDFLAGS = -v
TARGET = kernel.bin

# Order currently matters to the linker!
OBJS =  zeropage.o kernel.o via.o sound.o lcd.o \
	acia.o binhex.o stdlib.o term.o command.o xmodem.o \
	clock.o

LDMAP = krisos.map

all: kernel.bin

zeropage.o: zeropage.s
	$(CA) $(CFLAGS) -o $@ $<

via.o: via.s
	$(CA) $(CFLAGS) -o $@ $<

sound.o: sound.s
	$(CA) $(CFLAGS) -o $@ $<

lcd.o: lcd.s
	$(CA) $(CFLAGS) -o $@ $<

acia.o: acia.s
	$(CA) $(CFLAGS) -o $@ $<

binhex.o: binhex.s
	$(CA) $(CFLAGS) -o $@ $<

stdlib.o: stdlib.s
	$(CA) $(CFLAGS) -o $@ $<

term.o: term.s
	$(CA) $(CFLAGS) -o $@ $<

command.o: command.s
	$(CA) $(CFLAGS) -o $@ $<

xmodem.o: xmodem.s
	$(CA) $(CFLAGS) -o $@ $<

clock.o: clock.s
	$(CA) $(CFLAGS) -o $@ $<

kernel.o: kernel.s
	$(CA) $(CFLAGS) -o $@ $<

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -C krisos.cfg -m krisos.map -o $(TARGET) $(OBJS) 

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET) $(LDMAP)

.PHONY: burn
burn:
	minipro -p AT28C256 -w kernel.bin

.PHONY: terminal
terminal:
	picocom -b 19200 --send-cmd 'sz -X' /dev/cu.usbserial-DN05JN76
