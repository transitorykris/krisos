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

%.o: %.s
	$(CA) $(CFLAGS) -o $@ $<

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -C krisos.cfg -m krisos.map -o $(TARGET) $(OBJS) 

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET) $(LDMAP)

.PHONY: burn
burn: $(TARGET)
	minipro -p AT28C256 -w $(TARGET)

.PHONY: terminal
terminal:
	picocom -b 19200 --send-cmd 'sz -X' /dev/cu.usbserial-DN05JN76
