; KrisOS LCD Library
;
; Copyright 2020 Kris Foster
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

.ifndef _LIB_LCD_
_LIB_LCD = 1

    .setcpu "6502"
    .psc02                      ; Enable 65c02 opcodes

    .include "lcd.inc"
    .include "via.inc"
    .include "../term/term.inc" ; XXX this is probably a bad sign

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