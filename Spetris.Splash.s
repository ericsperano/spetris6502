***
*** Display the splash screen and wait for any key to be pressed
*** It increments the random seed while it waits for a key
***
SplashScreen    jsr HOME                        ; clear screen
                DO ]USE_EXT_CHAR
                sta ALTCHARSETON                ; enable alt charset
                FIN
                JSRDisplayStr Splash00
                JSRDisplayStr Splash01
                JSRDisplayStr Splash02
                JSRDisplayStr Splash03
                JSRDisplayStr Splash04
                JSRDisplayStr Splash05
                JSRDisplayStr Splash06
                JSRDisplayStr Splash07
                JSRDisplayStr Splash08
                JSRDisplayStr Splash09
                JSRDisplayStr Splash10
splashLoop0     clc                             ; increment the 32bit seed
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
                bcc splashLoop0                 ; no, loop
                sta STROBE
                rts
                * splash screen strings
                DO ]USE_EXT_CHAR
Splash00        dfb $8b,$04,16
                asc "S P E T R // S !"
                ELSE
Splash00        dfb $8b,$04,16
                asc "S P E T R ][ S !"
                FIN
                DO ]USE_EXT_CHAR
Splash01        dfb $86,$05,25
                asc "For "
                dfb $40
                asc " Apple //e Computers"
                ELSE
Splash01        dfb $87,$05,22
                asc "By Eric Sperano (2021)"
                FIN
Splash02        dfb $30,$04,22
                asc "Keyboard Game Controls"
Splash03        dfb $30,$05,19
                DO ]USE_EXT_CHAR
                dfb $4b
                ELSE
                dfb "Z"
                FIN
                asc "      Rotate Piece"
Splash04        dfb $b0,$05,22
                DO ]USE_EXT_CHAR
                dfb $48
                ELSE
                dfb "N"
                FIN
                asc "      Move Piece Left"
Splash05        dfb $30,$06,23
                DO ]USE_EXT_CHAR
                dfb $55
                ELSE
                dfb "M"
                FIN
                asc "      Move Piece Right"
Splash06        dfb $b0,$06,22
                DO ]USE_EXT_CHAR
                dfb $4a
                ELSE
                dfb "X"
                FIN
                asc "      Move Piece Down"
Splash07        dfb $30,$07,17
                asc "Space  Drop Piece"
Splash08        dfb $b0,$07,17
                asc "P      Pause Game"
Splash09        dfb $58,$04,16
                asc "Esc    Quit Game"
Splash10        dfb $d8,$06,22
                asc "Press Any Key To Start"
