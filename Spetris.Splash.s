***
*** Display the splash screen and wait for any key to be pressed
*** It increments the random seed while it waits for a key
***
SplashScreen    jsr HOME                        ; clear screen
                sta ALTCHARSETON                ; enable alt charset
                JSRDisplayLine Splash00
                JSRDisplayLine Splash01
                JSRDisplayLine Splash02
                JSRDisplayLine Splash03
                JSRDisplayLine Splash04
                JSRDisplayLine Splash05
                JSRDisplayLine Splash06
                JSRDisplayLine Splash07
                JSRDisplayLine Splash08
                JSRDisplayLine Splash09
                JSRDisplayLine Splash10
splashLoop0     clc                             ; increment the 32bit seed
                lda Rand1
                adc #1
                sta Rand1
                lda Rand2
                adc #0
                sta Rand2
                lda Rand3
                adc #0
                sta Rand3
                lda Rand4
                adc #0
                sta Rand4
                lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc splashLoop0                 ; no, loop
                sta STROBE
                rts
                * splash screen strings
Splash00        dfb $8b,$04,16
                asc "S P E T R // S !"
Splash01        dfb $87,$05,24
                asc "For "
                dfb $40
                asc " Apple // Computers"
Splash02        dfb $30,$04,22
                asc "Keyboard Game Controls"
Splash03        dfb $30,$05,19
                dfb $4b
                asc "      Rotate Piece"
Splash04        dfb $b0,$05,22
                dfb $48
                asc "      Move Piece Left"
Splash05        dfb $30,$06,23
                dfb $55
                asc "      Move Piece Right"
Splash06        dfb $b0,$06,22
                dfb $4a
                asc "      Move Piece Down"
Splash07        dfb $30,$07,17
                asc "Space  Drop Piece"
Splash08        dfb $b0,$07,17
                asc "P      Pause Game"
Splash09        dfb $58,$04,16
                asc "Esc    Quit Game"
Splash10        dfb $d8,$06,22
                asc "Press Any Key To Start"
