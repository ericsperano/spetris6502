***
*** Increment the score
*** Formula is  ((1 << lines) * 100) + 25
*** We cheat by indexing a pre-calcultated points table
***
IncScore        lda LinesCount                  ; y will be the index for the points table
                asl                             ; multiply linescount by 2 because each entry is 2 bytes
                tay
                iny                             ; lo byte is in +1
                ldx #3                          ; start index for ScoreBCD TODO constants
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
                lda ScoreBCD,x                  ; add carry on the last two bytes
                adc #0
                sta ScoreBCD,x
                dex
                lda ScoreBCD,x
                adc #0
                sta ScoreBCD,x
                cld                             ; binary mode
                * 32 bits comparisons of Score and HighScore
                ldx #0                          ; compare hihghest byte first
isCmpLoop       lda ScoreBCD,x
                cmp HighScoreBCD,x
                beq isNextByte                  ; same value, compare next character
                bcs isUpdScoreLoop              ; acuumulator > memory (score byte > high score)
                bcc isEndCmp                    ; accumulator < memory (score byte < high score)
isNextByte      inx
                cpx #4                          ; end of BCD number? TODO constant
                bne isCmpLoop                   ; keep comparing
isEndCmp        rts                             ; no need to update high score, return
isUpdScoreLoop  lda ScoreBCD,x
                sta HighScoreBCD,x
                inx
                cpx #4
                bne isUpdScoreLoop
                rts
***
***
***
HighScore       dfb $9d,$06,$04
HighScoreBCD    dfb $00,$00,$00,$00 ; bcd encoded
Score           dfb $1d,$07,$04
ScoreBCD        dfb $00,$00,$00,$00 ; bcd encoded
