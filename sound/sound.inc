; KrisOS Sound Library
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

.ifndef _SOUND_H_
_SOUND_H_ = 1


; Data formats
; LCCTDDDD
; Latch indicator
; Channel
; Register type (0=tone, 1=volume)
; Data
; 1CCTDDDD (latch byte)
; 0-DDDDDD (data byte)
FIRST           = %10000000
SECOND          = %00000000
CHANNEL_1       = %00000000
CHANNEL_2       = %00100000
CHANNEL_3       = %01000000
CHANNEL_NOISE   = %01100000
TONE            = %00000000
VOLUME          = %00010000
VOLUME_OFF      = %00001111
VOLUME_MAX      = %00000000
SN_READY        = %00000001 ; Ready pin
SN_WE           = %00000010 ; Write enable pin (active low)
SN_WE_CLEAR     = %00000000
SN_CE           = %00000100 ; Chip enable pin (active low) - Tied to ground
SN_DATA         = %11111111 ; Data pins

; Notes
; Note, (s)harp/(f)lat/(n)atural, octave, byte 1 or 2
Cn0_1 = $00
Cn0_2 = $00 ; 12 C0
Cs0_1 = $00
Cs0_2 = $00 ; 13 C#0/Db0
Dn0_1 = $00
Dn0_2 = $00 ; 14 D0
Ds0_1 = $00
Ds0_2 = $00 ; 15 D#0/Eb0
En0_1 = $00
En0_2 = $00 ; 16 E0
Fn0_1 = $00
Fn0_2 = $00 ; 17 F0
Fs0_1 = $00
Fs0_2 = $00 ; 18 F#0/Gb0
Gn0_1 = $00
Gn0_2 = $00 ; 19 G0
Gs0_1 = $00
Gs0_2 = $00 ; 20 G#0/Ab0
An0_1 = $00
An0_2 = $00 ; 21 A0
As0_1 = $00
As0_2 = $00 ; 22 A#0/Bb0
Bn0_1 = $00
Bn0_2 = $00 ; 23 B0
Cn1_1 = $00
Cn1_2 = $00 ; 24 C1
Cs1_1 = $00
Cs1_2 = $00 ; 25 C#1/Db1
Dn1_1 = $00
Dn1_2 = $00 ; 26 D1
Ds1_1 = $00
Ds1_2 = $00 ; 27 D#1/Eb1
En1_1 = $00
En1_2 = $00 ; 28 E1
Fn1_1 = $00
Fn1_2 = $00 ; 29 F1
Fs1_1 = $00
Fs1_2 = $00 ; 30 F#1/Gb1
Gn1_1 = $00
Gn1_2 = $00 ; 31 G1
Gs1_1 = $00
Gs1_2 = $00 ; 32 G#1/Ab1
An1_1 = $00
An1_2 = $00 ; 33 A1
As1_1 = $00
As1_2 = $00 ; 34 A#1/Bb1
Bn1_1 = $04
Bn1_2 = $3f ; 35 B1
Cn2_1 = $0b
Cn2_2 = $3b ; 36 C2
Cs2_1 = $05
Cs2_2 = $38 ; 37 C#2/Db2
Dn2_1 = $03
Dn2_2 = $35 ; 38 D2
Ds2_1 = $03
Ds2_2 = $32 ; 39 D#2/Eb2
En2_1 = $06
En2_2 = $2f ; 40 E2
Fn2_1 = $0b
Fn2_2 = $2c ; 41 F2
Fs2_1 = $03
Fs2_2 = $2a ; 42 F#2/Gb2
Gn2_1 = $0d
Gn2_2 = $27 ; 43 G2
Gs2_1 = $09
Gs2_2 = $25 ; 44 G#2/Ab2
An2_1 = $08
An2_2 = $23 ; 45 A2
As2_1 = $08
As2_2 = $21 ; 46 A#2/Bb2
Bn2_1 = $0a
Bn2_2 = $1f ; 47 B2
Cn3_1 = $0d
Cn3_2 = $1d ; 48 C3
Cs3_1 = $02
Cs3_2 = $1c ; 49 C#3/Db3
Dn3_1 = $09
Dn3_2 = $1a ; 50 D3
Ds3_1 = $01
Ds3_2 = $19 ; 51 D#3/Eb3
En3_1 = $0b
En3_2 = $17 ; 52 E3
Fn3_1 = $05
Fn3_2 = $16 ; 53 F3
Fs3_1 = $01
Fs3_2 = $15 ; 54 F#3/Gb3
Gn3_1 = $0e
Gn3_2 = $13 ; 55 G3
Gs3_1 = $0c
Gs3_2 = $12 ; 56 G#3/Ab3
An3_1 = $0c
An3_2 = $11 ; 57 A3
As3_1 = $0c
As3_2 = $10 ; 58 A#3/Bb3
Bn3_1 = $0d
Bn3_2 = $0f ; 59 B3
Cn4_1 = $0e
Cn4_2 = $0e ; 60 C4
Cs4_1 = $01
Cs4_2 = $0e ; 61 C#4/Db4
Dn4_1 = $04
Dn4_2 = $0d ; 62 D4
Ds4_1 = $08
Ds4_2 = $0c ; 63 D#4/Eb4
En4_1 = $0d
En4_2 = $0b ; 64 E4
Fn4_1 = $02
Fn4_2 = $0b ; 65 F4
Fs4_1 = $08
Fs4_2 = $0a ; 66 F#4/Gb4
Gn4_1 = $0f
Gn4_2 = $09 ; 67 G4
Gs4_1 = $06
Gs4_2 = $09 ; 68 G#4/Ab4
An4_1 = $0e
An4_2 = $08 ; 69 A4
As4_1 = $06
As4_2 = $08 ; 70 A#4/Bb4
Bn4_1 = $0e
Bn4_2 = $07 ; 71 B4
Cn5_1 = $07
Cn5_2 = $07 ; 72 C5
Cs5_1 = $00
Cs5_2 = $07 ; 73 C#5/Db5
Dn5_1 = $0a
Dn5_2 = $06 ; 74 D5
Ds5_1 = $04
Ds5_2 = $06 ; 75 D#5/Eb5
En5_1 = $0e
En5_2 = $05 ; 76 E5
Fn5_1 = $09
Fn5_2 = $05 ; 77 F5
Fs5_1 = $04
Fs5_2 = $05 ; 78 F#5/Gb5
Gn5_1 = $0f
Gn5_2 = $04 ; 79 G5
Gs5_1 = $0b
Gs5_2 = $04 ; 80 G#5/Ab5
An5_1 = $07
An5_2 = $04 ; 81 A5
As5_1 = $03
As5_2 = $04 ; 82 A#5/Bb5
Bn5_1 = $0f
Bn5_2 = $03 ; 83 B5
Cn6_1 = $0b
Cn6_2 = $03 ; 84 C6
Cs6_1 = $08
Cs6_2 = $03 ; 85 C#6/Db6
Dn6_1 = $05
Dn6_2 = $03 ; 86 D6
Ds6_1 = $02
Ds6_2 = $03 ; 87 D#6/Eb6
En6_1 = $0f
En6_2 = $02 ; 88 E6
Fn6_1 = $0c
Fn6_2 = $02 ; 89 F6
Fs6_1 = $0a
Fs6_2 = $02 ; 90 F#6/Gb6
Gn6_1 = $07
Gn6_2 = $02 ; 91 G6
Gs6_1 = $05
Gs6_2 = $02 ; 92 G#6/Ab6
An6_1 = $03
An6_2 = $01 ; 96 C7
Cs7_1 = $0c
Cs7_2 = $01 ; 97 C#7/Db7
Dn7_1 = $0a
Dn7_2 = $01 ; 98 D7
Ds7_1 = $09
Ds7_2 = $01 ; 99 D#7/Eb7
En7_1 = $07
En7_2 = $01 ; 100 E7
Fn7_1 = $06
Fn7_2 = $01 ; 101 F7
Fs7_1 = $05
Fs7_2 = $01 ; 102 F#7/Gb7
Gn7_1 = $03
Gn7_2 = $01 ; 103 G7
Gs7_1 = $02
Gs7_2 = $01 ; 104 G#7/Ab7
An7_1 = $01
An7_2 = $01 ; 105 A7
As7_1 = $00
As7_2 = $01 ; 106 A#7/Bb7
Bn7_1 = $0f
Bn7_2 = $00 ; 107 B7
Cn8_1 = $0e
Cn8_2 = $00 ; 108 C8
Cs8_1 = $0e
Cs8_2 = $00 ; 109 C#8/Db8
Dn8_1 = $0d
Dn8_2 = $00 ; 110 D8
Ds8_1 = $0c
Ds8_2 = $00 ; 111 D#8/Eb8
En8_1 = $0b
En8_2 = $00 ; 112 E8
Fn8_1 = $0b
Fn8_2 = $00 ; 113 F8
Fs8_1 = $0a
Fs8_2 = $00 ; 114 F#8/Gb8
Gn8_1 = $09
Gn8_2 = $00 ; 115 G8
Gs8_1 = $09
Gs8_2 = $00 ; 116 G#8/Ab8
An8_1 = $08
An8_2 = $00 ; 117 A8
As8_1 = $08
As8_2 = $00 ; 118 A#8/Bb8
Bn8_1 = $07
Bn8_2 = $00 ; 119 B8%

.endif