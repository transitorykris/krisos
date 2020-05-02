; KrisOS sid.inc
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

.ifndef _SID_H_
_SID_H_ = 1

    .import __SID_START__

.enum
    SID_VOICE1_FREQ_LO = __SID_START__
    SID_VOICE1_FREQ_HI
    SID_VOICE1_PW_LO
    SID_VOICE1_PW_HI
    SID_VOICE1_CTRL_REG         ; Control register
    SID_VOICE1_AD               ; Attack/Decay
    SID_VOICE1_SR               ; Sustain/Release

    SID_VOICE2_FREQ_LO
    SID_VOICE2_FREQ_HI
    SID_VOICE2_PW_LO
    SID_VOICE2_PW_HI
    SID_VOICE2_CTRL_REG         ; Control register
    SID_VOICE2_AD               ; Attack/Decay
    SID_VOICE2_SR               ; Sustain/Release

    SID_VOICE3_FREQ_LO
    SID_VOICE3_FREQ_HI
    SID_VOICE3_PW_LO
    SID_VOICE3_PW_HI
    SID_VOICE3_CTRL_REG         ; Control register
    SID_VOICE3_AD               ; Attack/Decay
    SID_VOICE3_SR               ; Sustain/Release

    SID_FILTER_FC_LO
    SID_FILTER_FC_HI
    SID_FILTER_RS
    SID_FILTER_MV

    SID_MISC_POTX
    SID_MISC_POTY
    SID_MISC_OSC3               ;OSC3/Random
    SID_MISC_ENV3
.endenum

; Equal-tempered musical scale values
c0n = $0112
c0s = $0123
d0n = $0134
d0s = $0146
e0n = $015A
f0n = $016E
f0s = $0184
g0n = $018B
g0s = $01B3
a0n = $01CD
a0s = $01E9
b0n = $0206
c1n = $0225
c1s = $0245
d1n = $0268
d1s = $028C
e1n = $02B3
f1n = $02DC
f1s = $0308
g1n = $0336
g1s = $0367
a1n = $039B
a1s = $03D2
b1n = $040C
c2n = $0449
c2s = $048B
d2n = $04D0
d2s = $0519
e2n = $0567
f2n = $05B9
f2s = $0610
g2n = $066C
g2s = $06CE
a2n = $0735
a2s = $07A3
b2n = $0817
c3n = $0893
c3s = $0915
d3n = $099F
d3s = $0A32
e3n = $0ACD
f3n = $0B72
f3s = $0C20
g3n = $0C08
g3s = $0D9C
a3n = $0E6B
a3s = $0F46
b3n = $102F
c4n = $1125
c4s = $122A
d4n = $133F
d4s = $1464
e4n = $159A
f4n = $16E3
f4s = $183F
g4n = $1981
g4s = $1B38
a4n = $1CD6
a4s = $1E80
b4n = $205E
c5n = $224B
c5s = $2455
d5n = $267E
d5s = $28C8
e5n = $2B34
f5n = $2DC6
f5s = $307F
g5n = $3361
g5s = $366F
a5n = $39AC
a5s = $3D1A
b5n = $40BC
c6n = $4495
c6s = $48A9
d6n = $4CFC
d6s = $518F
e6n = $5669
f6n = $5B8C
f6s = $60FE
g6n = $6602
g6s = $6CDF
a6n = $7358
a6s = $7A34
b6n = $8178
c7n = $892B
c7s = $9153
d7n = $99F7
d7s = $A31F
e7n = $ACD2
f7n = $B719
f7s = $C1FC
g7n = $C085
g7s = $0980
a7n = $E6B0
a7s = $F467

.endif