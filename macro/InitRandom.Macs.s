;***
;*** InitRandom - Generate a few random numbers to kick things off
;***
.macro          InitRandom
                ldx #$20
@loop:          jsr RandomNumber
                dex
                bne @loop
.endmacro
