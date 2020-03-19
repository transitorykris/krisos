; KrisOS Zeropage globals for XModem
; Copyright 2020 Kris Foster

.ifndef _XMODEM_ZP_
_XMODEM_ZP_ = 1

    .exportzp lastblk
    .exportzp blkno 
    .exportzp errcnt
    .exportzp bflag
    .exportzp crc
    .exportzp crch
    .exportzp ptr
    .exportzp ptrh
    .exportzp eofp
    .exportzp eofph
    .exportzp retry
    .exportzp retry2

lastblk:    .res 1              ; flag for last block
blkno:      .res 1              ; block number
errcnt:     .res 1              ; error counter 10 is the limit
bflag:      .res 1              ; block flag
crc:        .res 1              ; CRC lo byte  (two byte variable)
crch:       .res 1              ; CRC hi byte
ptr:        .res 1              ; data pointer (two byte variable)
ptrh:       .res 1              ;   "    "
eofp:       .res 1              ; end of file address pointer (2 bytes)
eofph:      .res 1              ;  " " " "
retry:      .res 1              ; retry counter
retry2:     .res 1              ; 2nd counter

.endif