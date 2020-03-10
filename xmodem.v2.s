 ; https://raw.githubusercontent.com/andi8086/R8/master/xmodem.s
        .export XModemRcv

; XMODEM/CRC Receiver for the 65C02
;
; By Daryl Rictor & Ross Archer  Aug 2002
;
; 21st century code for 20th century CPUs (tm?)
; 
; A simple file transfer program to allow upload from a console device
; to the SBC utilizing the x-modem/CRC transfer protocol.  Requires just
; under 1k of either RAM or ROM, 132 bytes of RAM for the receive buffer,
; and 8 bytes of zero page RAM for variable storage.
;
;**************************************************************************
; This implementation of XMODEM/CRC does NOT conform strictly to the 
; XMODEM protocol standard in that it (1) does not accurately time character
; reception or (2) fall back to the Checksum mode.

; (1) For timing, it uses a crude timing loop to provide approximate
; delays.  These have been calibrated against a 1MHz CPU clock.  I have
; found that CPU clock speed of up to 5MHz also work but may not in
; every case.  Windows HyperTerminal worked quite well at both speeds!
;
; (2) Most modern terminal programs support XMODEM/CRC which can detect a
; wider range of transmission errors so the fallback to the simple checksum
; calculation was not implemented to save space.
;**************************************************************************
;
; Files uploaded via XMODEM-CRC must be
; in .o64 format -- the first two bytes are the load address in
; little-endian format:  
;  FIRST BLOCK
;     offset(0) = lo(load start address),
;     offset(1) = hi(load start address)
;     offset(2) = data byte (0)
;     offset(n) = data byte (n-2)
;
; Subsequent blocks
;     offset(n) = data byte (n)
;
; The TASS assembler and most Commodore 64-based tools generate this
; data format automatically and you can transfer their .obj/.o64 output
; file directly.  
;   
; The only time you need to do anything special is if you have 
; a raw memory image file (say you want to load a data
; table into memory). For XMODEM you'll have to 
; "insert" the start address bytes to the front of the file.
; Otherwise, XMODEM would have no idea where to start putting
; the data.

;-------------------------- The Code ----------------------------
;
; zero page variables (adjust these to suit your needs)
;
;
ptr     =   $3a     ; data pointer (two byte variable)
ptrh        =   $3b     ;   "    "

blkno       =   $3c     ; block number 
retry       =   $3d     ; retry counter 
retry2      =   $3e     ; 2nd counter
bflag       =   $3f     ; block flag 
;
;
; non-zero page variables and buffers
;
;
Rbuff       =   $0200       ; temp 132 byte receive buffer 
                    ;(place anywhere, page aligned)

ACIA_DATA       = $4000
ACIA_STATUS     = $4001
;
;
;  tables and constants
;
;
; XMODEM Control Character Constants
SOH     =   $01     ; start block
EOT     =   $04     ; end of text marker
ACK     =   $06     ; good block acknowledged
NAK     =   $15     ; bad block acknowledged
CAN     =   $18     ; cancel (not standard, not supported)
CR      =   $0d     ; carriage return
LF      =   $0a     ; line feed
ESC     =   $1b     ; ESC to exit

;
;^^^^^^^^^^^^^^^^^^^^^^ Start of Program ^^^^^^^^^^^^^^^^^^^^^^
;
; Xmodem/CRC upload routine
; By Daryl Rictor, July 31, 2002
;
; v0.3  tested good minus CRC
; v0.4  CRC fixed!!! init to $0000 rather than $FFFF as stated   
; v0.5  added CRC tables vs. generation at run time
; v 1.0 recode for use with SBC2
; v 1.1 added block 1 masking (block 257 would be corrupted)
; v 1.2 removed CRC code

.SEGMENT "LIB"       ; Start of program (adjust to your needs)
;
XModemRcv:      jsr PrintMsg    ; send prompt and info
        lda #$01
        sta blkno       ; set block # to 1
        sta bflag       ; set flag to get address from block 1
StartCrc:    lda #'C'    ; "C" start with CRC mode
        jsr Put_Chr     ; send it
        lda #$FF    
        sta retry2      ; set loop counter for ~3 sec delay
        lda #$00
        jsr GetByte     ; wait for input
                bcs GotByte     ; byte received, process it
        bcc StartCrc    ; resend "C"

StartBlk:    lda #$FF        ; 
        sta retry2      ; set loop counter for ~3 sec delay
        lda #$00        ;
        jsr GetByte     ; get first byte of block
        bcc StartBlk    ; timed out, keep waiting...
GotByte:     cmp #ESC        ; quitting?
                bne GotByte1    ; no
;       lda #$FE        ; Error code in "A" of desired
;                brk         ; YES - do BRK or change to RTS if desired
        jmp $F800
GotByte1:        cmp #SOH        ; start of block?
        beq BegBlk      ; yes
        jmp Done        ; EOT - all done!
BegBlk:      ldx #$00
GetBlk:      lda #$ff        ; 3 sec window to receive characters
        sta     retry2      ;
GetBlk1:     jsr GetByte     ; get next character
        bcc BadCrc      ; chr rcv error, flush and send NAK
GetBlk2:     sta Rbuff,x     ; good char, save it in the rcv buffer
        inx         ; inc buffer pointer    
        cpx #$84        ; <01> <FE> <128 bytes> <CRCH> <CRCL>
        bne GetBlk      ; get 132 characters
        ldx #$00        ;
        lda Rbuff,x     ; get block # from buffer
        cmp blkno       ; compare to expected block #   
        beq GoodBlk1    ; matched!
        jsr Print_Err   ; Unexpected block number - abort   
        jsr Flush       ; mismatched - flush buffer and then do BRK
;       lda #$FD        ; put error code in "A" if desired
;        brk         ; unexpected block # - fatal error - BRK or RTS
        jmp $F800
GoodBlk1:    eor #$ff        ; 1's comp of block #
        inx         ;
        cmp Rbuff,x     ; compare with expected 1's comp of block #
        beq GoodBlk2    ; matched!
        jsr Print_Err   ; Unexpected block number - abort   
        jsr     Flush       ; mismatched - flush buffer and then do BRK
;       lda #$FC        ; put error code in "A" if desired
;        brk         ; bad 1's comp of block#    
        jmp $F800
GoodBlk2:    ldy #$02        ; 
CalcCrc:     lda Rbuff,y     ; calculate the CRC for the 128 bytes of data   
        iny         ;
        jmp GoodCrc
BadCrc:      jsr Flush       ; flush the input port
        lda #NAK        ;
        jsr Put_Chr     ; send NAK to resend block
        jmp StartBlk    ; start over, get the block again           
GoodCrc:     ldx #$02        ;
        lda blkno       ; get the block number
        cmp #$01        ; 1st block?
        bne CopyBlk     ; no, copy all 128 bytes
        lda bflag       ; is it really block 1, not block 257, 513 etc.
        beq CopyBlk     ; no, copy all 128 bytes
        lda Rbuff,x     ; get target address from 1st 2 bytes of blk 1
        sta ptr     ; save lo address
        inx         ;
        lda Rbuff,x     ; get hi address
        sta ptr+1       ; save it
        inx         ; point to first byte of data
        dec bflag       ; set the flag so we won't get another address      
CopyBlk:     ldy #$00        ; set offset to zero
CopyBlk3:    lda Rbuff,x     ; get data byte from buffer
        sta (ptr),y     ; save to target
        inc ptr     ; point to next address
        bne CopyBlk4    ; did it step over page boundary?
        inc ptr+1       ; adjust high address for page crossing
CopyBlk4:    inx         ; point to next data byte
        cpx #$82        ; is it the last byte
        bne CopyBlk3    ; no, get the next one
IncBlk:      inc blkno       ; done.  Inc the block #
        lda #ACK        ; send ACK
        jsr Put_Chr     ;
        jmp StartBlk    ; get next block
Done:        lda #ACK        ; last block, send ACK and exit.
        jsr Put_Chr     ;
        jsr Flush       ; get leftover characters, if any
        jsr Print_Good  ;
        rts         ;
;
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
; subroutines
;
;                   ;
GetByte:     lda #$00        ; wait for chr input and cycle timing loop
        sta retry       ; set low value of timing loop
StartCrcLp:  jsr Get_Chr     ; get chr from serial port, don't wait 
        bcs GetByte1    ; got one, so exit
        dec retry       ; no character received, so dec counter
        bne StartCrcLp  ;
        dec retry2      ; dec hi byte of counter
        bne StartCrcLp  ; look for character again
        clc         ; if loop times out, CLC, else SEC and return
GetByte1:    rts         ; with character in "A"
;
Flush:       lda #$70        ; flush receive buffer
        sta retry2      ; flush until empty for ~1 sec.
Flush1:      jsr GetByte     ; read the port
        bcs Flush       ; if chr recvd, wait for another
        rts         ; else done
;
PrintMsg:    ldx #$00        ; PRINT starting message
PrtMsg1:     lda     Msg,x       
        beq PrtMsg2         
        jsr Put_Chr
        inx
        bne PrtMsg1
PrtMsg2:     rts
Msg:     .byte   "XMOD"
        .BYTE   CR, LF
                .byte   0
;
Print_Err:   ldx #$00        ; PRINT Error message
PrtErr1:     lda     ErrMsg,x
        beq PrtErr2
        jsr Put_Chr
        inx
        bne PrtErr1
PrtErr2:     rts
ErrMsg:      .byte   "ERR"
        .BYTE   CR, LF
                .byte   0
;
Print_Good:  ldx #$00        ; PRINT Good Transfer message
Prtgood1:    lda     GoodMsg,x
        beq Prtgood2
        jsr Put_Chr
        inx
        bne Prtgood1
Prtgood2:    rts
GoodMsg:     .byte   "OK"
        .BYTE   CR, LF
                .byte   0
;
;
;======================================================================
;  I/O Device Specific Routines
;
;  Two routines are used to communicate with the I/O device.
;
; "Get_Chr" routine will scan the input port for a character.  It will
; return without waiting with the Carry flag CLEAR if no character is
; present or return with the Carry flag SET and the character in the "A"
; register if one was present.
;
; "Put_Chr" routine will write one byte to the output port.  Its alright
; if this routine waits for the port to be ready.  its assumed that the 
; character was send upon return from this routine.
;
; Here is an example of the routines used for a standard 6551 ACIA.
; You would call the ACIA_Init prior to running the xmodem transfer
; routine.
;
;ACIA_Data   =   $8040       ; Adjust these addresses to point 
;ACIA_Status =   $8041       ; to YOUR 6551!
;ACIA_Command =  $8042       ;
;ACIA_Control =  $8043       ;

;ACIA_Init:       lda #$1F            ; 19.2K/8/1
;                sta ACIA_Control    ; control reg 
;                lda #$0B            ; N parity/echo off/rx int off/ dtr active low
;                sta ACIA_Command    ; command reg 
;                rts                     ; done
;
; input chr from ACIA (no waiting)
;
Get_Chr:     clc         ; no chr present
                lda ACIA_STATUS     ; get Serial port status
                and #$08            ; mask rcvr full bit
                beq Get_Chr2    ; if not chr, done
                Lda ACIA_DATA       ; else get chr
            sec         ; and set the Carry Flag
Get_Chr2:        rts         ; done
;
; output to OutPut Port
;
Put_Chr:     PHA                     ; save registers
Put_Chr1:        lda ACIA_STATUS     ; serial port status
                and #$10            ; is tx buffer empty
                beq Put_Chr1        ; no, go back and test it again
                PLA                     ; yes, get chr to send
                sta ACIA_DATA       ; put character to Port
                RTS                     ; done
;
; End of File
;
