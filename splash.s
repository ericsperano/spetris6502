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
SplashTitle     da $048b
                dfb 16,
                asc "S P E T R // S !"
SplashAuthor    da $0588
                dfb 22
                asc "By Eric Sperano (2021)"
SplashForApl    da $0685
                dfb 28
                asc "For The "
                dfb $40
                asc " Apple //e Computer"
SplashGameCtrl  da $042f
                dfb 24
                asc ' '
                dfb $0b
                asc 'eyboard '
                dfb $07
                asc 'ame '
                dfb $03
                asc 'ontrols '
SplashKeyLeft   da $052f
                dfb 20,
                dfb $48
                asc "          Move Left"
SplashKeyRight  da $05af
                dfb 21
                dfb $55
                asc "          Move Right"
SplashKeyUp     da $062f
                dfb 17
                dfb $4b
                asc " or A     Rotate"
SplashKeyDown   da $06af
                dfb 20
                dfb $4a
                asc " or Z     Move Down"
SplashKeySpace  da $072f
                dfb 15
                asc "Space      Drop"
SplashKeyP      da $04d7
                dfb 16
                asc "P          Pause"
SplashKey1      da $0557
                dfb 24
                asc "Tab        Change Style!"
SplashKeyEsc    da $0657
                dfb 15
                asc "Q          Quit"
SplashAnyKey    da $0757
                dfb 24
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
SplashTitle     da $048b
                dfb 16
                asc "S P E T R ][ S !"
SplashAuthor    da $0588
                dfb 22
                asc "BY ERIC SPERANO (2021)"
SplashForApl    da $0688
                dfb 22
                asc "FOR APPLE ][ COMPUTERS"
SplashGameCtrl  da $042f
                dfb 24
                inv " KEYBOARD GAME CONTROLS "
SplashKeyLeft   da $052c
                dfb 28
                asc "LEFT ARROW         MOVE LEFT"
SplashKeyRight  da $05ac
                dfb 29
                asc "RIGHT ARROW        MOVE RIGHT"
SplashKeyUp     da $062c
                dfb 25
                asc "A                  ROTATE"
SplashKeyDown   da $06ac
                dfb 28
                asc "Z                  MOVE DOWN"
SplashKeySpace  da $072c
                dfb 23
                asc "SPACE              DROP"
SplashKeyP      da $04d4
                dfb 24
                asc "P                  PAUSE"
SplashKey1      da $0554
                dfb 32
                asc "TAB                CHANGE STYLE!"
SplashKeyEsc    da $0654
                dfb 23
                asc "Q                  QUIT"
SplashAnyKey    da $0757
                dfb 24
                inv ' PRESS ANY KEY TO START '
                FIN
;SplashAnyKeyX   da $0757
;                dfb 24
;                ds 24, ' '
