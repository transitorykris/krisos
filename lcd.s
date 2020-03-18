; KrisOS LCD Library
; Copyright 2020 Kris Foster

.ifndef _LIB_LCD_
_LIB_LCD = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "lcd.h"
    .include "via.h"
    .include "term.h"

    .importzp string_ptr

    .export lcd_init
    .export lcd_write

    .segment "LIB"

lcd_init:
    PHA
    LDA #(LCD_FUNCTION_SET|LCD_EIGHTBIT|LCD_TWOLINE)
    JSR send_lcd_command
    LDA #(LCD_CURSOR_DISPLAY|LCD_DISPLAY_ON|LCD_CURSOR_ON|LCD_BLINK_OFF)
    JSR send_lcd_command
    LDA #(LCD_DISPLAY_CTRL|LCD_LEFTRIGHT|LCD_SHIFT)
    JSR send_lcd_command
    LDA #(LCD_RETURN_HOME)
    JSR send_lcd_command
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    LDA #(LCD_CLEAR_DISPLAY)
    JSR send_lcd_command
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    jsr wait
    PLA
    RTS

send_lcd_command:
    JSR wait
    STA VIA1_PORTB
    LDA #$01                    ; Clear RS/RW/E bits
    STA VIA1_PORTA
    JSR wait
    LDA #LCD_ENABLE             ; Set E bit to send instruction
    STA VIA1_PORTA
    JSR wait
    LDA #$01                    ; Clear RS/RW/E bits
    STA VIA1_PORTA
    RTS

; Need to write proper busy checking code
wait:
    PHX
    LDX #$00
wait_loop:
    CPX #$0F
    BEQ wait_done
    INX
wait_done:
    PLX
    RTS

lcd_write:
    PHY
    LDY #00
lcd_write_loop:
    JSR wait
    LDA (string_ptr), y
    BEQ lcd_write_done          ; NULL will make us branch
    JSR write_lcd
    INY
    JMP lcd_write_loop
lcd_write_done:
    PLY
    RTS

write_lcd:
    JSR wait
    STA VIA1_PORTB
    LDA #LCD_RS                 ; Set RS; Clear RW/E bits
    STA VIA1_PORTA
    JSR wait
    LDA #(LCD_RS|LCD_ENABLE)    ; Set E bit to send instruction
    STA VIA1_PORTA
    JSR wait
    LDA #LCD_RS                 ; Clear E bits
    STA VIA1_PORTA
    RTS

.endif