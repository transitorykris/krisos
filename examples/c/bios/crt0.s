; A hacked up example based on
; https://cc65.github.io/doc/customizing.html

    .setcpu "6502"
    .PSC02

    .import _main
    .export _init
    .export _exit

    .import __RAM_START__   ; Linker generated
    .import __RAM_SIZE__    ; Linker generated
    .export __STARTUP__ : absolute = 1        ; Mark as startup

    .import copydata
    .import zerobss
    .import initlib
    .import donelib

    .include  "zeropage.inc"

    .segment  "STARTUP"

_init:
    NOP                     ; Nothing to do here.. yet
    LDA #<(__RAM_START__ + __RAM_SIZE__)    ; Argument stack pointers
    STA sp
    LDA #>(__RAM_START__ + __RAM_SIZE__)
    STA sp+1

    JSR zerobss              ; Clear BSS segment
    JSR copydata             ; Initialize DATA segment
    JSR initlib              ; Run constructors

    JSR _main           ; Main function from our C program

_exit:
    JSR donelib             ; Run destructors
    RTS                     ; Return control to KrisOS
