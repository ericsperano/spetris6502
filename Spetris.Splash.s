***
*** Display a menu asking which charset to use
*** Set FlagMouseText to 1 if user choose MouseText
***
MenuCharset     jsr HOME
                sta ALTCHARSETOFF
                JSRDisplayStr Splash00
                JSRDisplayStr Splash00b
                JSRDisplayStr Splash01Reg
                JSRDisplayStr MenuMouseText
                JSRDisplayStr MenuRegular
mcKeyLoop       lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc mcKeyLoop                   ; no, keep polling
                sta STROBE                      ; key pressed
                cmp #Key1                       ; key 1 pressed?
                bne mcCmpKey2                   ; no, check key 2
                lda #1
                sta FlagMouseText               ; yes, use mousetext
                jsr UseMTCharset
                rts
mcCmpKey2       cmp #Key2                       ; key 2 pressed?
                bne mcKeyLoop                   ; no, loop
                lda #0
                sta FlagMouseText               ; use regular ASCII charset
                jsr UseRegCharset
                rts
***
*** Display the splash screen and wait for any key to be pressed
*** It increments the random seed while it waits for a key
***
SplashScreen    jsr HOME                        ; clear screen
                lda FlagMouseText               ; mouse text selected?
                beq splashDispReg               ; no, skip enabling
                sta ALTCHARSETON                ; enable alt charset
splashDisplay   JSRDisplayStr Splash01MT        ; display mouse text strings
                JSRDisplayStr Splash03MT
                JSRDisplayStr Splash04MT
                JSRDisplayStr Splash05MT
                JSRDisplayStr Splash06MT
                JSRDisplayStr Splash07MT
                JSRDisplayStr Splash08MT
                JSRDisplayStr Splash09MT
                JSRDisplayStr Splash10MT
                jmp splashDispRest
splashDispReg   JSRDisplayStr Splash01Reg       ; display regular ascii strings
                JSRDisplayStr Splash03Reg
                JSRDisplayStr Splash04Reg
                JSRDisplayStr Splash05Reg
                JSRDisplayStr Splash06Reg
                JSRDisplayStr Splash07Reg
                JSRDisplayStr Splash08Reg
                JSRDisplayStr Splash09Reg
                JSRDisplayStr Splash10Reg
splashDispRest  JSRDisplayStr Splash00          ; display rest of the strings
                JSRDisplayStr Splash00b
                JSRDisplayStr Splash02
                JSRDisplayStr Splash11
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
***
*** Charset Menu strings
***
MenuMouseText   dfb $a8,$05,35
                asc "Press 1 to use MouseText characters"
MenuRegular     dfb $a8,$07,39
                asc "Press 2 to use regular ASCII characters"
***
*** Splash Screen strings
***
Splash00        dfb $8b,$04,16
                asc "S P E T R ][ S !"
Splash01MT      dfb $87,$06,24
                asc "For "
                dfb $40
                asc " Apple ][ Computers"
Splash03MT      dfb $2f,$05,20
                dfb $4b
                asc " or A  Rotate Piece"
Splash04MT      dfb $af,$05,23
                dfb $48
                asc "       Move Piece Left"
Splash05MT      dfb $2f,$06,24
                dfb $55
                asc "       Move Piece Right"
Splash06MT      dfb $af,$06,23
                dfb $4a
                asc " or Z  Move Piece Down"
Splash07MT      dfb $2f,$07,18
                asc "Space   Drop Piece"
Splash08MT      dfb $af,$07,18
                asc "P       Pause Game"
Splash09MT      dfb $57,$04,20
                asc "1       Change Style!"
Splash10MT      dfb $D7,$04,17
                asc "Esc     Quit Game"
Splash01Reg     dfb $88,$06,22
                asc "For Apple ][ Computers"
Splash03Reg     dfb $2a,$05,30
                asc "Up Arrow or A     Rotate Piece"
Splash04Reg     dfb $aa,$05,33
                asc "Left Arrow        Move Piece Left"
Splash05Reg     dfb $2a,$06,34
                asc "Right Arrow       Move Piece Right"
Splash06Reg     dfb $aa,$06,33
                asc "Down Arrow or Z   Move Piece Down"
Splash07Reg     dfb $2a,$07,28
                asc "Space             Drop Piece"
Splash08Reg     dfb $aa,$07,28
                asc "P                 Pause Game"
Splash09Reg     dfb $52,$04,30
                asc "1                 Change Style!"
Splash10Reg     dfb $d2,$04,27
                asc "Esc               Quit Game"
Splash00b       dfb $88,$05,22
                asc "By Eric Sperano (2021)"
Splash02        dfb $30,$04,22
                asc "Keyboard Game Controls"
Splash11        dfb $d8,$06,22
                asc "Press Any Key To Start"
