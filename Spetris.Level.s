;***
;***
;***TODO check if substract < 0
CheckLevel:     ldx LinesCount
clLoop0:        sed                             ; decimal mode
                clc
                lda TotalLinesBCD+1             ; increment total lines counter
                adc #1
                sta TotalLinesBCD+1
                lda TotalLinesBCD
                adc #0
                sta TotalLinesBCD
                lda TotalLinesBCD+1             ; check the low byte ends with 0
                and #$0f
                bne clSvCounter                 ; not a divider of 10, loop
                lda LevelBCD                    ; increment level
                clc
                adc #1
                sta LevelBCD
                cld                             ; clear decimal, speed limit is binary
                sec                             ; set carry for substraction
                lda SpeedLimit+1                ; speed lo byte
                sbc #$30                        ; substract $30
                sta SpeedLimit+1
                lda SpeedLimit                  ; speed hi byte
                sbc #0
                sta SpeedLimit
clSvCounter:    dex
                bne clLoop0
                cld                             ; binary mode
                rts
;***
;***
;***
Level:          .byte $a3,$07,$01
LevelBCD:       .byte $00
TotalLines:     .byte $c9,$04,$02
TotalLinesBCD:  .byte $00,$00
SpeedCount:     .byte 0,0
SpeedLimit:     .byte 0,0
