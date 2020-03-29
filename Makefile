CA = ca65
CFLAGS =
LD = ld65
LDFLAGS = -v
LDCFG = krisos.cfg
LDMAP = krisos.map
TARGET = kernel.bin
SERIAL = /dev/cu.usbserial-DN05JN76

# Order currently matters to the linker!
OBJS =  zeropage.o \
	kernel.o \
	io/via.o \
	sound/sound.o \
	io/lcd.o \
	io/acia.o \
	util/binhex.o \
	stdlib/stdlib.o \
	term/term.o \
	term/command.o \
	xmodem/xmodem.o \
	util/clock.o

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
