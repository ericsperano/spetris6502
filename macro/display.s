;
; Enable Mouse Text characters
;
AltCharSetOn    MAC
                DO ]APPLE2E
                sta ALTCHARSETON                ; enable alternate char set
                FIN
                <<<
;
; Disable Mouse Text characters
;
AltCharSetOff   MAC
                DO ]APPLE2E
                sta ALTCHARSETOFF               ; disable alternate char set
                FIN
                <<<
;
; Display a BCD structure
;
JSRDisplayBCD   MAC
                InitPtr ]1;PtrDisplayStr
                jsr DisplayBCD
                <<<
;
; Display a String structure
;
JSRDisplayStr   MAC
                InitPtr ]1;PtrDisplayStr
                jsr DisplayStr
                <<<
;
; Set the FlagRefreshScr to On
;
SetFlagRefresh  MAC
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
                <<<
;
;
;
DisplayStats    MAC
                JSRDisplayStr Title             ; display all the right side labels
                JSRDisplayStr HighScoreL
                JSRDisplayBCD HighScore
                JSRDisplayStr ScoreL
                JSRDisplayBCD Score
                JSRDisplayStr LevelL
                JSRDisplayBCD Level
                JSRDisplayStr TotalPiecesL
                JSRDisplayBCD TotalPieces
                JSRDisplayStr TotalLinesL
                JSRDisplayBCD TotalLines
                JSRDisplayStr NextPieceL
                <<<
