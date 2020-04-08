;
; Increment the score
; Formula is  ((1 << lines) * 100) + 25
; We cheat by indexing a pre-calcultated points table
;
IncScore        lda LinesCount                  ; y will be the index for the points table
                asl                             ; multiply linescount by 2 because each entry is 2 bytes
                tay
                iny                             ; lo byte is in +1
                ldx #3                          ; start index for ScoreBCD TODO constants
                clc
                sed                             ; set decimal mode
                lda ScoreBCD,x                  ; load lowest byte of score
                adc (PtrPoints),y               ; add lo byte of points to a
                sta ScoreBCD,x                  ; store in score
                dex                             ; decrement indexes
                dey
                lda ScoreBCD,x                  ; load 2nd lowest byte of score
                adc (PtrPoints),y               ; add hi byte of points to a
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
                ; 32 bits comparisons of Score and HighScore
                ldx #0                          ; compare hihghest byte first
]cmpLoop        lda ScoreBCD,x
                cmp HighScoreBCD,x
                beq :nextByte                   ; same value, compare next character
                bcs :updateLoop                 ; acuumulator > memory (score byte > high score)
                bcc :endCmp                     ; accumulator < memory (score byte < high score)
:nextByte       inx
                cpx #4                          ; end of BCD number? TODO constant
                bne ]cmpLoop                    ; keep comparing
:endCmp         rts                             ; no need to update high score, return
:updateLoop     lda ScoreBCD,x
                sta HighScoreBCD,x
                inx
                cpx #4
                bne :updateLoop
                rts
;
;
;
HighScore       dfb $9d,$06,$04
HighScoreBCD    dfb $00,$00,$00,$00 ; bcd encoded
Score           dfb $1d,$07,$04
ScoreBCD        dfb $00,$00,$00,$00 ; bcd encoded
PointsTable     dfb $00,$25,$02,$25,$04,$25,$08,$25,$16,$25 ; points for 0 to 4 lines, 2 bytes bcd
