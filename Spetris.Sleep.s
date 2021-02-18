;***
;*** Sleep
;***
Sleep:          phx
                ldx #SleepTime
@loop:          dex
                bne @loop
                plx
                rts
SleepTime       = $ff
