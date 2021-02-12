***
***
***
Title           dfb $93,$05,16
                DO ]USE_EXT_CHAR
                asc "S P E T R // S !"
                ELSE
                asc "S P E T R ][ S !"
                FIN
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
