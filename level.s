;
; TODO check if substract < 0
;
CheckLevel      ldx LinesCount
]loop           sed                             ; decimal mode
                clc
                lda TotalLinesBCD+1             ; increment total lines counter
                adc #1
                sta TotalLinesBCD+1
                lda TotalLinesBCD
                adc #0
                sta TotalLinesBCD
                lda TotalLinesBCD+1             ; check the low byte ends with 0
                and #$0f
                bne :endloop                    ; not a divider of 10, loop
                lda LevelBCD                    ; increment level
                clc
                adc #1
                sta LevelBCD
                cld                             ; clear decimal, speed limit is binary
                sec                             ; set carry for substraction
                lda SpeedLimit+1                ; speed lo byte
                sbc #$40                        ; substract chunk from speed limit
                sta SpeedLimit+1
                lda SpeedLimit                  ; speed hi byte
                sbc #0
                sta SpeedLimit
:endloop        dex
                bne ]loop
                cld                             ; binary mode
                rts
;
;
;
Level           dfb $a3,$07,$01
LevelBCD        dfb $00
TotalLines      dfb $c9,$04,$02
TotalLinesBCD   dfb $00,$00
SpeedCount      dfb 0,0
SpeedLimit      dfb 0,0
