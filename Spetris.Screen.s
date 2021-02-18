;***
;*** SetScreenPos
;*** Set PTR_ScreenPos with register x,y
;***
SetScreenPos:   phy
                phx
                tya
                asl ; multiply by 2 because each array elem is 2 bytes (an address)
                tay
                stx SSP_X
                InitPtr FieldPositions, PTR_FieldPos
                clc
                lda (PTR_FieldPos),y
                adc SSP_X
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                ;*adc #0   ; negative numbers set the carry bit
                sta PTR_ScreenPos+1
                plx
                ply
                rts
;*
SSP_X:          .byte 0 ; to rename X tmp TODO
;***
;***
;***
Title:          .byte $93, $05, 16, "S P E T R ][ S !"
HighScoreL:     .byte $90,$06,11
                .byte "High Score:"
ScoreL:         .byte $10,$07,6
                .byte "Score:"
LevelL:         .byte $90,$07,6
                .byte "Level:"
TotalPiecesL:   .byte $38,$04,13
                .byte "Total Pieces:"
TotalLinesL:    .byte $b8,$04,12
                .byte "Total Lines:"
NextPieceL:     .byte $38,$06,11
                .byte "Next Piece:"
PausedL:        .byte $de,$06,11
                .byte "P A U S E D"
NewGameL:       .byte $dd,$06,13
                .byte "New Game? Y/N"
PausedBlankL:   .byte $de,$06,11
                .byte "           "
