all: hello ascii chess break clock via_test sound
.PHONY: all

.PHONY: hello
hello:
	ca65 -I ../ hello.s
	ld65 -C examples.cfg -o hello.raw hello.o
	printf "\x00\x10" | cat - hello.raw > hello.bin

.PHONY: ascii
ascii:
	ca65 -I ../ ascii.s
	ld65 -C examples.cfg -o ascii.raw ascii.o
	printf "\x00\x10" | cat - ascii.raw > ascii.bin

.PHONY: chess
chess:
	ca65 -I ../ chess.s
	ld65 -C examples.cfg -o chess.raw chess.o
	printf "\x00\x10" | cat - chess.raw > chess.bin

.PHONY: break
break:
	ca65 -I ../ break.s
	ld65 -C examples.cfg -o break.raw break.o
	printf "\x00\x10" | cat - break.raw > break.bin

.PHONY: clock
clock:
	ca65 -I ../ clock.s
	ld65 -C examples.cfg -o clock.raw clock.o
	printf "\x00\x10" | cat - clock.raw > clock.bin

.PHONY: via_test
via_test:
	ca65 -I ../ via_test.s
	ld65 -C examples.cfg -o via_test.raw via_test.o
	printf "\x00\x10" | cat - via_test.raw > via_test.bin

.PHONY: sound
sound:
	ca65 -I ../ sound.s
	ld65 -C examples.cfg -o sound.raw sound.o
	printf "\x00\x10" | cat - sound.raw > sound.bin

clean:
	rm *.o
	rm *.raw
	rm *.bin
