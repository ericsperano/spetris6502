***
*** RandomNumber - Generate a 32 bits random number in Rand1-4
***
***
RandomNumber    ror Rand4       ; Bit 25 to carry
                lda Rand3       ; Shift left 8 bits
                sta Rand4
                lda Rand2
                sta Rand3
                lda Rand1
                sta Rand2
                lda Rand4       ; Get original bits 17-24
                ror             ; Now bits 18-25 in ACC
                rol Rand1       ; R1 holds bits 1-7
                eor Rand1       ; Seven bits at once
                ror Rand4       ; Shift right by one bit
                ror Rand3
                ror Rand2
                ror
                sta Rand1
                rts
***
*** InitRandom - Generate a few random numbers to kick things off
***
InitRandom      ldx #$20
irLoop          jsr RandomNumber
                dex
                bne irLoop
                rts
***
*** 32 bits random number. Rand1 is lowest byte, Rand4 the highest
***
Rand1           dfb 0
Rand2           dfb 0
Rand3           dfb 0
Rand4           dfb 0
