***
*** InitRandom - Generate a few random numbers to kick things off
***
InitRandom      MAC
                ldx #$20
irLoop          jsr RandomNumber
                dex
                bne irLoop
                <<<
