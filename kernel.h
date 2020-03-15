; KrisOS - kernel.h
; Copyright 2020 Kris Foster

.ifndef _LCD_H_
_LCD_H_ = 1

; Kernel messages

calling_msg: .byte "Starting",CR,LF,LF,NULL
bad_command_msg: .byte "Unknown command, type help for help",CR,LF,NULL
shutdown_msg: .byte "Shutting down...",CR,LF,NULL

.endif