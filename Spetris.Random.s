***
*** RandomNumber - Generate a 32 bits random number in Rand1-4
***
RandomNumber    ror Rand+3      ; Bit 25 to carry
                lda Rand+2      ; Shift left 8 bits
                sta Rand+3
                lda Rand+1
                sta Rand+2
                lda Rand
                sta Rand+1
                lda Rand+3      ; Get original bits 17-24
                ror             ; Now bits 18-25 in ACC
                rol Rand        ; R1 holds bits 1-7
                eor Rand        ; Seven bits at once
                ror Rand+3      ; Shift right by one bit
                ror Rand+2
                ror Rand+1
                ror
                sta Rand
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
*** 32 bits random number.
***
Rand           dfb 0,0,0,0
