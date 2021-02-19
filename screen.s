;
; SetScreenPos
; Set PTR_ScreenPos with register x,y
;
SetScreenPos    phy
                phx
                tya
                asl ; multiply by 2 because each array elem is 2 bytes (an address)
                tay
                stx tmp1
                InitPtr FieldPositions;PtrFieldPos
                clc
                lda (PtrFieldPos),y
                adc tmp1
                sta PtrScreenPos
                iny
                lda (PtrFieldPos),y
                ;adc #0   ; negative numbers set the carry bit
                sta PtrScreenPos+1
                plx
                ply
                rts
;
;SSP_X           dfb 0 ; to rename X tmp TODO
;
;
;
                DO ]APPLE2E
Title           dfb $93,$05,16
                asc "S P E T R // S !"
HighScoreL      dfb $90,$06,11
                asc "High Score:"
ScoreL          dfb $10,$07,6
                asc "Score:"
LevelL          dfb $90,$07,6
                asc "Level:"
TotalPiecesL    dfb $38,$04,13
                asc "Total Pieces:"
TotalLinesL     dfb $b8,$04,12
                asc "Total Lines:"
NextPieceL      dfb $38,$06,11
                asc "Next Piece:"
NewGameL        dfb $dd,$06,13
                asc "New Game? Y/N"
PausedL         dfb $de,$06,11
                asc "P A U S E D"
                ELSE
Title           dfb $93,$05,16
                asc "S P E T R ][ S !"
HighScoreL      dfb $90,$06,11
                asc "HIGH SCORE:"
ScoreL          dfb $10,$07,6
                asc "SCORE:"
LevelL          dfb $90,$07,6
                asc "LEVEL:"
TotalPiecesL    dfb $38,$04,13
                asc "TOTAL PIECES:"
TotalLinesL     dfb $b8,$04,12
                asc "TOTAL LINES:"
NextPieceL      dfb $38,$06,11
                asc "NEXT PIECE:"
NewGameL        dfb $dd,$06,13
                asc "NEW GAME? Y/N"
PausedL         dfb $de,$06,11
                asc "P A U S E D"
                FIN
PausedBlankL    dfb $de,$06,11
                asc "           "
