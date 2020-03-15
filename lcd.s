; KrisOS LCD Library
; Copyright 2020 Kris Foster

.ifndef _LIB_LCD_
_LIB_LCD = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "lcd.h"
    .include "via.h"

    .export lcd_init
    .export lcd_hello

    .segment "LIB"

lcd_init:
    LDA #(LCD_FUNCTION_SET|LCD_EIGHTBIT|LCD_TWOLINE)
    JSR send_lcd_command
    LDA #(LCD_CURSOR_DISPLAY|LCD_DISPLAY_ON|LCD_CURSOR_ON|LCD_BLINK_OFF)
    JSR send_lcd_command
    LDA #(LCD_DISPLAY_CTRL|LCD_LEFTRIGHT|LCD_SHIFT)
    JSR send_lcd_command
    RTS

lcd_hello:
    lda #'H'
    JSR write_lcd
    lda #'e'
    JSR write_lcd
    lda #'l'
    JSR write_lcd
    lda #'l'
    JSR write_lcd
    lda #'o'
    JSR write_lcd
    lda #','
    JSR write_lcd
    lda #' '
    JSR write_lcd
    lda #'w'
    JSR write_lcd
    lda #'o'
    JSR write_lcd
    lda #'r'
    JSR write_lcd
    lda #'l'
    JSR write_lcd
    lda #'d'
    JSR write_lcd
    lda #'!'
    JSR write_lcd
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
    ;LDX #$00
wait_loop:
    CPX #$0F
    BEQ wait_done
    INX
wait_done:
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