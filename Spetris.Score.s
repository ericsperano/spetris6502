***
***
***
IncScore        lda LinesCount                  ; y will be the index for the points table
                asl                             ; multiply linescount by 2 because each entry is 2 bytes
                tay
                iny                             ; lo byte is in +1
                ldx #3                          ; start index for ScoreBCD
                clc
                sed                             ; set decimal mode
                lda ScoreBCD,x                  ; load lowest byte of score
                adc (PTR_Points),y              ; add lo byte of points to a
                sta ScoreBCD,x                  ; store in score
                dex                             ; decrement indexes
                dey
                lda ScoreBCD,x                  ; load 2nd lowest byte of score
                adc (PTR_Points),y              ; add hi byte of points to a
                sta ScoreBCD,x                  ; store in score
                dex                             ; decrement index
                lda ScoreBCD,x
                adc #0
                sta ScoreBCD,x
                dex
                lda ScoreBCD,x
                adc #0
                sta ScoreBCD,x
                cld                             ; binary mode
                * 32 bits comparisons of Score and HighScore
                ldx #0
                lda HighScoreBCD,x
                cmp ScoreBCD,x
                bcc updateScore                  ; high score < score
                inx
                lda HighScoreBCD,x
                cmp ScoreBCD,x
                bcc updateScore                  ; high score < score
                inx
                lda HighScoreBCD,x
                cmp ScoreBCD,x
                bcc updateScore                  ; high score < score
                inx
                lda HighScoreBCD,x
                cmp ScoreBCD,x
                bcc updateScore                  ; high score < score
                jmp endCmpScore
updateScore     ldx #0
updateScoreL    lda ScoreBCD,x
                sta HighScoreBCD,x
                inx
                cpx #4
                bne updateScoreL
endCmpScore     rts
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
