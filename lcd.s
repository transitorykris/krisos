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
    LDA #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
    JSR send_lcd_command
    LDA #%00001110 ; Display on; cursor on; blink off
    JSR send_lcd_command
    LDA #%00000110 ; Increment and shift cursor; don't shift display
    JSR send_lcd_command

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

send_lcd_command:
    JSR wait
    STA VIA1_PORTB

    LDA #$01                    ; Clear RS/RW/E bits
    STA VIA1_PORTA

    LDA #LCD_ENABLE             ; Set E bit to send instruction
    STA VIA1_PORTA

    LDA #$01                    ; Clear RS/RW/E bits
    STA VIA1_PORTA
    RTS

; Need to write proper busy checking code
wait:
    LDX #$00
wait_loop:
    CPX #$FF
    BEQ wait_done
    INC
wait_done:
    RTS

write_lcd:
    JSR wait
    STA VIA1_PORTB

    LDA #LCD_RS                 ; Set RS; Clear RW/E bits
    STA VIA1_PORTA

    LDA #(LCD_RS|LCD_ENABLE)    ; Set E bit to send instruction
    STA VIA1_PORTA

    LDA #LCD_RS                 ; Clear E bits
    STA VIA1_PORTA
    RTS

.endif