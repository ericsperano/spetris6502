***
***
***
IncScore        lda LinesCount
                asl ; multiply by 2
                tay
                iny ; lo byte is in +1
                ldx #3  ; 4 bytes - 1
                clc
                sed
                lda ScoreBCD,x
                adc (PTR_Points),y
                sta ScoreBCD,x
                dex
                dey
                lda ScoreBCD,x
                adc (PTR_Points),y
                sta ScoreBCD,x
                dex
isLoop          lda ScoreBCD,x
                adc #0
                sta ScoreBCD,x
                dex
                bne isLoop
                cld ; binary mode
                rts
***
***
***
HighScoreL      dfb $90,$06,11
                asc "High Score:"
ScoreL          dfb $10,$07,6
                asc "Score:"
HighScore       dfb $9d,$06,$04
HighScoreBCD    dfb $00,$00,$00,$00 ; bcd encoded
Score           dfb $1d,$07,$04
ScoreBCD        dfb $00,$00,$00,$00 ; bcd encoded
