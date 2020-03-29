; XMODEM/CRC Sender/Receiver for the 65C02
;
; By Daryl Rictor Aug 2002
;
; A simple file transfer program to allow transfers between the SBC  and a
; console device utilizing the x-modem/CRC transfer protocol.  Requires
; ~1200 bytes of either RAM or ROM, 132 bytes of RAM for the receive buffer,
; and 12 bytes of zero page RAM for variable storage.
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
; Files transferred via XMODEM-CRC will have the load address contained in
; the first two bytes in little-endian format:
;  FIRST BLOCK
;     offset(0) = lo(load start address),
;     offset(1) = hi(load start address)
;     offset(2) = data byte (0)
;     offset(n) = data byte (n-2)
;
; Subsequent blocks
;     offset(n) = data byte (n)
;
; One note, XMODEM send 128 byte blocks.  If the block of memory that
; you wish to save is smaller than the 128 byte block boundary, then
; the last block will be padded with zeros.  Upon reloading, the
; data will be written back to the original location.  In addition, the
; padded zeros WILL also be written into RAM, which could overwrite other
; data.
;
; Modified to run on KrisOS, Kris Foster March 2020
;

.ifndef _LIB_XMODEM_
_LIB_XMODEM_ = 1

    .setcpu "6502"
    .PSC02                      ; Enable 65c02 opcodes

    .include "term.inc"
    .include "acia.inc"

    .importzp lastblk
    .importzp blkno 
    .importzp errcnt
    .importzp bflag
    .importzp crc
    .importzp crch
    .importzp ptr
    .importzp ptrh
    .importzp eofp
    .importzp eofph
    .importzp retry
    .importzp retry2

    .import acia_get_char
    .import acia_put_char

    .export XModemRcv

    .include "xmodem.inc"

    .segment "LIB"

;^^^^^^^^^^^^^^^^^^^^^^ Start of Program ^^^^^^^^^^^^^^^^^^^^^^
;
; Xmodem/CRC transfer routines
; By Daryl Rictor, August 8, 2002
;
; v1.0  released on Aug 8, 2002.
;
; Enter this routine with the beginning address stored in the zero page address
; pointed to by ptr & ptrh and the ending address stored in the zero page address
; pointed to by eofp & eofph.
;
;
XModemSend:
    JSR PrintMsg                ; send prompt and info
    LDA #$00                    ;
    STA errcnt                  ; error counter set to 0
    STA lastblk                 ; set flag to false
    LDA #$01                    ;
    STA blkno                   ; set block # to 1
Wait4CRC:
    LDA #$ff                    ; 3 seconds
    STA retry2                  ;
    JSR GetByte                 ;
    BCC Wait4CRC                ; wait for something to come in...
    CMP #'C'                    ; is it the "C" to STA rt a CRC xfer?
    BEQ SetstAddr               ; yes
    CMP #ESC                    ; is it a cancel? <Esc> Key
    BNE Wait4CRC                ; No, wait for another character
    JMP PrtAbort                ; Print abort msg and exit
SetstAddr:
    LDY #$00                    ; init data block offset to 0
    LDX #$04                    ; preload X to Receive buffer
    LDA #$01                    ; manually load blk number
    STA Rbuff                   ; into 1st byte
    LDA #$FE                    ; load 1's comp of block #
    STA Rbuff+1                 ; into 2nd byte
    LDA ptr                     ; load low byte of STA rt address
    STA Rbuff+2                 ; into 3rd byte
    LDA ptrh                    ; load hi byte of STA rt address
    STA Rbuff+3                 ; into 4th byte
    BRA LdBuff1                 ; jump into buffer load routine

LdBuffer:
    LDA lastblk                 ; Was the last block sent?
    BEQ LdBuff0                 ; no, send the next one
    JMP Done                    ; yes, we're done
LdBuff0:
    LDX #$02                    ; init pointers
    LDY #$00                    ;
    INC blkno                   ; INC  block counter
    LDA blkno                   ;
    STA Rbuff                   ; save in 1st byte of buffer
    EOR #$FF                    ;
    STA Rbuff+1                 ; save 1's comp of blkno next
LdBuff1:
    LDA (ptr),y                 ; save 128 bytes of data
    STA Rbuff,x                 ;
LdBuff2:
    SEC                         ;
    LDA eofp                    ;
    SBC ptr                     ; Are we at the last address?
    BNE LdBuff4                 ; no, INC  pointer and continue
    LDA eofph                   ;
    SBC ptrh                    ;
    BNE LdBuff4                 ;
    INC lastblk                 ; Yes, Set last byte flag
LdBuff3:
    INX                         ;
    CPX #$82                    ; Are we at the end of the 128 byte block?
    BEQ SCalcCRC                ; Yes, calc CRC
    LDA #$00                    ; Fill rest of 128 bytes with $00
    STA Rbuff,x                 ;
    BEQ LdBuff3                 ; Branch always
LdBuff4:
    INC ptr                     ; INC address pointer
    BNE LdBuff5                 ;
    INC ptrh                    ;
LdBuff5:
    INX                         ;
    CPX #$82                    ; last byte in block?
    BNE LdBuff1                 ; no, get the next
SCalcCRC:
    JSR CalcCRC
    LDA crch                    ; save Hi byte of CRC to buffer
    STA Rbuff,y                 ;
    INY                         ;
    LDA crc                     ; save lo byte of CRC to buffer
    STA Rbuff,y                 ;
Resend:
    LDX #$00                    ;
    LDA #SOH
    JSR acia_put_char                 ; send SOH
SendBlk:
    LDA Rbuff,x                 ; Send 132 bytes in buffer to the console
    JSR acia_put_char                 ;
    INX                         ;
    CPX #$84                    ; last byte?
    BNE SendBlk                 ; no, get next
    LDA #$FF                    ; yes, set 3 second delay
    STA retry2                  ; and
    JSR GetByte                 ; Wait for Ack/Nack
    BCC Seterror                ; No chr received after 3 seconds, resend
    CMP #ACK                    ; Chr received... is it:
    BEQ LdBuffer                ; ACK, send next block
    CMP #NAK                    ;
    BEQ Seterror                ; NAK, INC errors and resend
    CMP #ESC                    ;
    BEQ PrtAbort                ; Esc pressed to abort
    ; fall through to error counter
Seterror:
    INC errcnt                  ; INC error counter
    LDA errcnt                  ;
    CMP #$0A                    ; are there 10 errors? (Xmodem spec for failure)
    BNE Resend                  ; no, resend block
PrtAbort:
    JSR Flush                   ; yes, too many errors, flush buffer,
    JMP Print_Err               ; print error msg and exit
Done:
    JMP Print_Good              ; All Done..Print msg and exit
;
;
;
XModemRcv:
    JSR PrintMsg                ; send prompt and info
    LDA #$01
    STA blkno                   ; set block # to 1
    STA bflag                   ; set flag to get address from block 1
StartCrc:
    LDA #'C'                    ; "C" start with CRC mode
    JSR acia_put_char                 ; send it
    LDA #$FF
    STA retry2                  ; set loop counter for ~3 sec delay
    LDA #$00
    STA crc
    STA crch                    ; init CRC value
    JSR GetByte                 ; wait for input
    BCS GotByte                 ; byte received, process it
    BCC StartCrc                ; resend "C"

StartBlk:
    LDA #$FF                    ;
    STA retry2                  ; set loop counter for ~3 sec delay
    JSR GetByte                 ; get first byte of block
    BCC StartBlk                ; timed out, keep waiting...
GotByte:
    CMP #ESC                    ; quitting?
    BNE GotByte1                ; no
    ;LDA #$FE                    ; Error code in "A" of desired
    BRK                         ; YES - do BRK or change to RTS if desired
GotByte1:
    CMP #SOH                    ; Start of block?
    BEQ BegBlk                  ; yes
    CMP #EOT                    ;
    BNE BadCrc                  ; Not SOH or EOT, so flush buffer & send NAK
    JMP RDone                   ; EOT - all done!
BegBlk:
    LDX #$00
GetBlk:
    LDA #$ff                    ; 3 sec window to receive characters
    STA retry2                  ;
GetBlk1:
    JSR GetByte                 ; get next character
    BCC BadCrc                  ; chr rcv error, flush and send NAK
GetBlk2:
    STA Rbuff,x                 ; good char, save it in the rcv buffer
    INX                         ; INC buffer pointer
    CPX #$84                    ; <01> <FE> <128 bytes> <CRCH> <CRCL>
    BNE GetBlk                  ; get 132 characters
    LDX #$00                    ;
    LDA Rbuff,x                 ; get block # from buffer
    CMP blkno                   ; compare to expected block #
    BEQ GoodBlk1                ; matched!
    JSR Print_Err               ; Unexpected block number - abort
    JSR Flush                   ; mismatched - flush buffer and then do BRK
    ;lda #$FD                    ; put error code in "A" if desired
    BRK                         ; unexpected block # - fatal error - BRK or RTS
GoodBlk1:
    EOR #$ff                    ; 1's comp of block #
    INX                         ;
    CMP Rbuff,x                 ; compare with expected 1's comp of block #
    BEQ GoodBlk2                ; matched!
    JSR Print_Err               ; Unexpected block number - abort
    JSR Flush                   ; mismatched - flush buffer and then do BRK
    ;LDA #$FC                    ; put error code in "A" if desired
    BRK                         ; bad 1's comp of block#
GoodBlk2:
    JSR CalcCRC                 ; calc CRC
    LDA Rbuff,y                 ; get hi CRC from buffer
    CMP crch                    ; compare to calculated hi CRC
    BNE BadCrc                  ; bad crc, send NAK
    INY                         ;
    LDA Rbuff,y                 ; get lo CRC from buffer
    CMP crc                     ; compare to calculated lo CRC
    BEQ GoodCrc                 ; good CRC
BadCrc:
    JSR Flush                   ; flush the input port
    LDA #NAK                    ;
    JSR acia_put_char                 ; send NAK to resend block
    JMP StartBlk                ; Start over, get the block again
GoodCrc:
    LDX #$02                    ;
    LDA blkno                   ; get the block number
    CMP #$01                    ; 1st block?
    BNE CopyBlk                 ; no, copy all 128 bytes
    LDA bflag                   ; is it really block 1, not block 257, 513 etc.
    BEQ CopyBlk                 ; no, copy all 128 bytes
    LDA Rbuff,x                 ; get target address from 1st 2 bytes of blk 1
    STA ptr                     ; save lo address
    INX                         ;
    LDA Rbuff,x                 ; get hi address
    STA ptr+1                   ; save it
    INX                         ; point to first byte of data
    DEC bflag                   ; set the flag so we won't get another address
CopyBlk:
    LDY  #$00                   ; set offset to zero
CopyBlk3:
    LDA Rbuff,x                 ; get data byte from buffer
    STA (ptr),y                 ; save to target
    INC ptr                     ; point to next address
    BNE CopyBlk4                ; did it step over page boundary?
    INC ptr+1                   ; adjust high address for page crossing
CopyBlk4:
    INX                         ; point to next data byte
    CPX #$82                    ; is it the last byte
    BNE CopyBlk3                ; no, get the next one
IncBlk:
    INC blkno                   ; done. INC the block #
    LDA #ACK                    ; send ACK
    JSR acia_put_char                 ;
    JMP StartBlk                ; get next block

RDone:
    LDA #ACK                    ; last block, send ACK and exit.
    JSR acia_put_char                 ;
    JSR Flush                   ; get leftover characters, if any
    JSR Print_Good              ;
    RTS                         ;
;
;=========================================================================
;
; subroutines
;
GetByte:
    LDA #$00                    ; wait for chr input and cycle timing loop
    STA retry                   ; set low value of timing loop
StartCrcLp:
    JSR acia_get_char                 ; get chr from serial port, don't wait
    BCS GetByte1                ; got one, so exit
    DEC retry                   ; no character received, so dec counter
    BNE StartCrcLp              ;
    dec retry2                  ; dec hi byte of counter
    BNE StartCrcLp              ; look for character again
    CLC                         ; if loop times out, CLC, else SEC and return
GetByte1:
    RTS                         ; with character in "A"
;
Flush:
    LDA #$70                    ; flush receive buffer
    STA retry2                  ; flush until empty for ~1 sec.
Flush1:
    JSR GetByte                 ; read the port
    BCS Flush                   ; if chr recvd, wait for another
    RTS                         ; else done
;
PrintMsg:
    LDX #$00                    ; PRINT STA rting message
PrtMsg1:
    LDA Msg,x
    BEQ PrtMsg2
    JSR acia_put_char
    INX
    BNE PrtMsg1
PrtMsg2:
    RTS
;
Print_Err:
    LDX #$00                    ; PRINT Error message
PrtErr1:
    LDA ErrMsg,x
    BEQ PrtErr2
    JSR acia_put_char
    INX
    BNE PrtErr1
PrtErr2:
    RTS
;
Print_Good:
    LDX #$00                    ; PRINT Good Transfer message
Prtgood1:
    LDA GoodMsg,x
    BEQ Prtgood2
    JSR acia_put_char
    INX
    BNE Prtgood1
Prtgood2:
    RTS

;=========================================================================
;
;  CRC subroutines
;
CalcCRC:
    LDA #$00                    ; yes, calculate the CRC for the 128 bytes
    STA crc                     ;
    STA crch                    ;
    LDY #$02                    ;
CalcCRC1:
    LDA Rbuff,y                 ;
    EOR crc+1                   ; Quick CRC computation with lookup tables
    TAX                         ; updates the two bytes at crc & crc+1
    LDA crc                     ; with the byte send in the "A" register
    EOR crchi,X
    STA crc+1
    LDA crclo,X
    STA crc
    INY                         ;
    CPY #$82                    ; done yet?
    BNE CalcCRC1                ; no, get next
    RTS                         ; y=82 on exit

.endif