;
; Display the splash screen and wait for any key to be pressed
; It increments the random seed while it waits for a key
;
SplashScreen    jsr HOME                        ; clear screen
                AltCharSetOn
                JSRDisplayStr SplashTitle
                JSRDisplayStr SplashAuthor
                JSRDisplayStr SplashForApl
                JSRDisplayStr SplashGameCtrl
                JSRDisplayStr SplashKeyUp
                JSRDisplayStr SplashKeyLeft
                JSRDisplayStr SplashKeyRight
                JSRDisplayStr SplashKeyDown
                JSRDisplayStr SplashKeySpace
                JSRDisplayStr SplashKeyP
                JSRDisplayStr SplashKey1
                JSRDisplayStr SplashKeyEsc
                JSRDisplayStr SplashAnyKey
                lda #0
                sta TilesetID
                jsr UseTileset
                ;DO ]APPLE2E
                ;jsr UseMTCharset
                ;ELSE
                ;jsr UseRegCharset
                ;FIN
]loop           clc                             ; increment the 32bit seed
                lda Rand
                adc #1
                sta Rand
                lda Rand+1
                adc #0
                sta Rand+1
                lda Rand+2
                adc #0
                sta Rand+2
                lda Rand+3
                adc #0
                sta Rand+3
                lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc ]loop                       ; no, loop
                sta STROBE
                rts
;
; Splash Screen strings
;
                DO ]APPLE2E
SplashTitle     dfb $8b,$04,16
                asc "S P E T R // S !"
SplashAuthor    dfb $88,$05,22
                asc "By Eric Sperano (2021)"
SplashForApl    dfb $87,$06,25
                asc "For "
                dfb $40
                asc " Apple //e Computers"
SplashGameCtrl  dfb $30,$04,22
                asc "Keyboard Game Controls"
SplashKeyUp     dfb $2f,$05,20
                dfb $4b
                asc " or A  Rotate Piece"
SplashKeyLeft   dfb $af,$05,23
                dfb $48
                asc "       Move Piece Left"
SplashKeyRight  dfb $2f,$06,24
                dfb $55
                asc "       Move Piece Right"
SplashKeyDown   dfb $af,$06,23
                dfb $4a
                asc " or Z  Move Piece Down"
SplashKeySpace  dfb $2f,$07,18
                asc "Space   Drop Piece"
SplashKeyP      dfb $af,$07,18
                asc "P       Pause Game"
SplashKey1      dfb $57,$04,21
                asc "1       Change Style!"
SplashKeyEsc    dfb $D7,$04,17
                asc "Esc     Quit Game"
SplashAnyKey    dfb $d8,$06,22
                asc "Press Any Key To Start"
                ELSE
                ; APPLE II/II+
SplashTitle     dfb $8b,$04,16
                asc "S P E T R ][ S !"
SplashAuthor    dfb $88,$05,22
                asc "BY ERIC SPERANO (2021)"
SplashForApl    dfb $88,$06,22
                asc "FOR APPLE ][ COMPUTERS"
SplashGameCtrl  dfb $30,$04,22
                asc "KEYBOARD GAME CONTROLS"
SplashKeyUp     dfb $2b,$05,29
                asc "A                ROTATE PIECE"
SplashKeyLeft   dfb $ab,$05,32
                asc "LEFT ARROW       MOVE PIECE LEFT"
SplashKeyRight  dfb $2b,$06,33
                asc "RIGHT ARROW      MOVE PIECE RIGHT"
SplashKeyDown   dfb $ab,$06,32
                asc "Z                MOVE PIECE DOWN"
SplashKeySpace  dfb $2b,$07,27
                asc "SPACE            DROP PIECE"
SplashKeyP      dfb $ab,$07,27
                asc "P                PAUSE GAME"
SplashKey1      dfb $53,$04,30
                asc "1                CHANGE STYLE!"
SplashKeyEsc    dfb $d3,$04,26
                asc "ESC              QUIT GAME"
SplashAnyKey    dfb $d8,$06,22
                asc "PRESS ANY KEY TO START"
                FIN
