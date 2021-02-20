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
]loop           clc                             ; increment the 32bit seed
                lda Rand                        ; TODO should be a macro
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
SplashForApl    dfb $85,$06,28
                asc "For The "
                dfb $40
                asc " Apple //e Computer"
SplashGameCtrl  dfb $2f,$04,24
                asc ' '
                dfb $0b
                asc 'eyboard '
                dfb $07
                asc 'ame '
                dfb $03
                asc 'ontrols '
SplashKeyLeft   dfb $2f,$05,20
                dfb $48
                asc " or B     Move Left"
SplashKeyRight  dfb $af,$05,21
                dfb $55
                asc " or M     Move Right"
SplashKeyUp     dfb $2f,$06,17
                dfb $4b
                asc " or H     Rotate"
SplashKeyDown   dfb $af,$06,20
                dfb $4a
                asc " or N     Move Down"
SplashKeySpace  dfb $2f,$07,15
                asc "Space      Drop"
SplashKeyP      dfb $d7,$04,16
                asc "P          Pause"
SplashKey1      dfb $57,$05,24
                asc "1          Change Style!"
SplashKeyEsc    dfb $57,$06,15
                asc "Esc        Quit"
SplashAnyKey    dfb $57,$07,24
                asc ' '
                dfb $10
                asc 'ress '
                dfb $01
                asc 'ny '
                dfb $0b
                asc 'ey '
                dfb $14
                asc 'o '
                dfb $13
                asc 'tart '
                ELSE
                ; APPLE II/II+
SplashTitle     dfb $8b,$04,16
                asc "S P E T R ][ S !"
SplashAuthor    dfb $88,$05,22
                asc "BY ERIC SPERANO (2021)"
SplashForApl    dfb $88,$06,22
                asc "FOR APPLE ][ COMPUTERS"
SplashGameCtrl  dfb $2f,$04,24
                inv " KEYBOARD GAME CONTROLS "
SplashKeyLeft   dfb $2c,$05,28
                asc "B OR LEFT ARROW    MOVE LEFT"
SplashKeyRight  dfb $ac,$05,29
                asc "M OR RIGHT ARROW   MOVE RIGHT"
SplashKeyUp     dfb $2c,$06,25
                asc "A                  ROTATE"
SplashKeyDown   dfb $ac,$06,28
                asc "Z                  MOVE DOWN"
SplashKeySpace  dfb $2c,$07,23
                asc "SPACE              DROP"
SplashKeyP      dfb $d4,$04,24
                asc "P                  PAUSE"
SplashKey1      dfb $54,$05,32
                asc "1                  CHANGE STYLE!"
SplashKeyEsc    dfb $54,$06,23
                asc "ESC                QUIT"
SplashAnyKey    dfb $57,$07,24
                inv ' PRESS ANY KEY TO START '
                FIN
;SplashAnyKeyX   dfb $57,$07,24
;                ds 24, ' '
