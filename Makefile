CA = ca65
CFLAGS =
LD = ld65
LDFLAGS = -v
LDCFG = krisos.cfg
LDMAP = krisos.map
TARGET = kernel.bin
SERIAL = /dev/cu.usbserial-DN05JN76

# Order currently matters to the linker!
OBJS =  zeropage.o kernel.o via.o sound.o lcd.o \
	acia.o binhex.o stdlib.o term.o command.o xmodem.o \
	clock.o

all: $(TARGET)

%.o: %.s
	$(CA) $(CFLAGS) -o $@ $<

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -C $(LDCFG) -m $(LDMAP) -o $(TARGET) $(OBJS) 

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET) $(LDMAP)

.PHONY: burn
burn: $(TARGET)
	minipro -p AT28C256 -w $(TARGET)

.PHONY: terminal
terminal:
	picocom -b 19200 --send-cmd 'sz -X' $(SERIAL)
