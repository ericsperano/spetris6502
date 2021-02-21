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
;
;
                DO ]APPLE2E
Title           da $0593
                dfb 16
                asc "S P E T R // S !"
HighScoreL      da $0690
                dfb 11
                asc "High Score:"
ScoreL          da $0710
                dfb 6
                asc "Score:"
LevelL          da $0790
                dfb 6
                asc "Level:"
TotalPiecesL    da $0438
                dfb 7
                asc "Pieces:"
TotalLinesL     da $04b8
                dfb 6
                asc "Lines:"
NextPieceL      da $0638
                dfb 11
                asc "Next Piece:"
NewGameL        da $06dd
                dfb 13
                asc "New Game? Y/N"
PausedL         da $06de
                dfb 11
                asc "P A U S E D"
                ELSE
Title           da $0593
                dfb 16
                asc "S P E T R ][ S !"
HighScoreL      da $0690
                dfb 11
                asc "HIGH SCORE:"
ScoreL          da $0710
                dfb 6
                asc "SCORE:"
LevelL          da $0790
                dfb 6
                asc "LEVEL:"
TotalPiecesL    da $0438
                dfb 7
                asc "PIECES:"
TotalLinesL     da $04b8
                dfb 6
                asc "LINES:"
NextPieceL      da $0638
                dfb 11
                asc "NEXT PIECE:"
NewGameL        da $06dd
                dfb 13
                asc "NEW GAME? Y/N"
PausedL         da $06de
                dfb 11
                asc "P A U S E D"
                FIN
;
PausedBlankL    da $06de
                dfb 11
                ds 11, " "
