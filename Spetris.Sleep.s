***
*** Sleep
***
Sleep           phx
                ldx #SleepTime
sleepLoop       dex
                bne sleepLoop
                plx
                rts
SleepTime       equ $ff
