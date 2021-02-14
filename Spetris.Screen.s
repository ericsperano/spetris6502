***
*** SetScreenPos
*** Set PTR_ScreenPos with register x,y
***
SetScreenPos    phy
                phx
                tya
                asl ; multiply by 2 because each array elem is 2 bytes (an address)
                tay
                stx SSP_X
                InitPtr FieldPositions;PTR_FieldPos
                clc
                lda (PTR_FieldPos),y
                adc SSP_X
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                *adc #0   ; negative numbers set the carry bit
                sta PTR_ScreenPos+1
                plx
                ply
                rts
*
SSP_X           dfb 0 ; to rename X tmp TODO
***
***
***
Title           dfb $93,$05,16
                asc "S P E T R ][ S !"
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
PausedL         dfb $de,$06,11
                asc "P A U S E D"
NewGameL        dfb $dd,$06,13
                asc "New Game? Y/N"
PausedBlankL    dfb $de,$06,11
                asc "           "
