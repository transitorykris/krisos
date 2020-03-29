; KrisOS - lcd.h
; Copyright 2020 Kris Foster

.ifndef _LCD_H_
_LCD_H_ = 1

; Hitachi LCD
LCD_CLEAR          = %00000000   ; Clear all bits
LCD_ENABLE         = %10000001   ; Enable bit
LCD_RW             = %01000001   ; Read/Write bit
LCD_RS             = %00100001   ; Register select bit

LCD_FUNCTION_SET   = %00100000
LCD_EIGHTBIT       = %00010000   ; 8 bit mode
LCD_TWOLINE        = %00001000   ; 2 line mode
LCD_FIVEEIGHTFONT  = %00000100   ; 5x8 font

LCD_CURSOR_DISPLAY = %00001000
LCD_DISPLAY_ON     = %00000100
LCD_CURSOR_ON      = %00000010
LCD_BLINK_ON       = %00000001
LCD_BLINK_OFF      = %00000000

LCD_DISPLAY_CTRL   = %00000100
LCD_LEFTRIGHT      = %00000010   ; Direction is left to right
LCD_RIGHTLEFT      = %00000000
LCD_DONT_SHIFT     = %00000001   ; Don't shift the display
LCD_SHIFT          = %00000000

LCD_CLEAR_DISPLAY  = %00000001
LCD_RETURN_HOME    = %00000010

.macro writeln_lcd str_addr
    LDA #<str_addr
    STA string_ptr
    LDA #>str_addr
    STA string_ptr+1
    JSR lcd_write
.endmacro

.endif