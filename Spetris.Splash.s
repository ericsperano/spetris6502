;***
;*** Display a menu asking which charset to use
;*** Set FlagMouseText to 1 if user choose MouseText
;***
MenuCharset:    jsr HOME
                sta ALTCHARSETOFF
                JSRDisplayStr Splash00
                JSRDisplayStr Splash00b
                JSRDisplayStr Splash01Reg
                JSRDisplayStr MenuMouseText
                JSRDisplayStr MenuRegular
mcKeyLoop:      lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc mcKeyLoop                   ; no, keep polling
                sta STROBE                      ; key pressed
                cmp #Key1                       ; key 1 pressed?
                bne mcCmpKey2                   ; no, check key 2
                lda #1
                sta FlagMouseText               ; yes, use mousetext
                jsr UseMTCharset
                rts
mcCmpKey2:      cmp #Key2                       ; key 2 pressed?
                bne mcKeyLoop                   ; no, loop
                lda #0
                sta FlagMouseText               ; use regular ASCII charset
                jsr UseRegCharset
                rts
;***
;*** Display the splash screen and wait for any key to be pressed
;*** It increments the random seed while it waits for a key
;***
SplashScreen:   jsr HOME                        ; clear screen
                lda FlagMouseText               ; mouse text selected?
                beq splashDispReg               ; no, skip enabling
                sta ALTCHARSETON                ; enable alt charset
                JSRDisplayStr Splash01MT        ; display mouse text strings
                JSRDisplayStr Splash03MT
                JSRDisplayStr Splash04MT
                JSRDisplayStr Splash05MT
                JSRDisplayStr Splash06MT
                JSRDisplayStr Splash07MT
                JSRDisplayStr Splash08MT
                JSRDisplayStr Splash09MT
                JSRDisplayStr Splash10MT
                jmp splashDispRest
splashDispReg:  JSRDisplayStr Splash01Reg       ; display regular .byteii strings
                JSRDisplayStr Splash03Reg
                JSRDisplayStr Splash04Reg
                JSRDisplayStr Splash05Reg
                JSRDisplayStr Splash06Reg
                JSRDisplayStr Splash07Reg
                JSRDisplayStr Splash08Reg
                JSRDisplayStr Splash09Reg
                JSRDisplayStr Splash10Reg
splashDispRest: JSRDisplayStr Splash00          ; display rest of the strings
                JSRDisplayStr Splash00b
                JSRDisplayStr Splash02
                JSRDisplayStr Splash11
splashLoop0:    clc                             ; increment the 32bit seed
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
;***
;*** Charset Menu strings
;***
MenuMouseText:  .byte $a8,$05,35
                .byte "Press 1 to use MouseText characters"
MenuRegular:    .byte $a8,$07,39
                .byte "Press 2 to use regular ASCII characters"
;***
;*** Splash Screen strings
;***
Splash00:       .byte $8b,$04,16
                .byte "S P E T R ][ S !"
Splash01MT:     .byte $87,$06,24
                .byte "For "
                .byte $40
                .byte " Apple ][ Computers"
Splash03MT:     .byte $2f,$05,20
                .byte $4b
                .byte " or A  Rotate Piece"
Splash04MT:     .byte $af,$05,23
                .byte $48
                .byte "       Move Piece Left"
Splash05MT:     .byte $2f,$06,24
                .byte $55
                .byte "       Move Piece Right"
Splash06MT:     .byte $af,$06,23
                .byte $4a
                .byte " or Z  Move Piece Down"
Splash07MT:     .byte $2f,$07,18
                .byte "Space   Drop Piece"
Splash08MT:     .byte $af,$07,18
                .byte "P       Pause Game"
Splash09MT:     .byte $57,$04,20
                .byte "1       Change Style!"
Splash10MT:     .byte $D7,$04,17
                .byte "Esc     Quit Game"
Splash01Reg:    .byte $88,$06,22
                .byte "For Apple ][ Computers"
Splash03Reg:    .byte $2a,$05,30
                .byte "Up Arrow or A     Rotate Piece"
Splash04Reg:    .byte $aa,$05,33
                .byte "Left Arrow        Move Piece Left"
Splash05Reg:    .byte $2a,$06,34
                .byte "Right Arrow       Move Piece Right"
Splash06Reg:    .byte $aa,$06,33
                .byte "Down Arrow or Z   Move Piece Down"
Splash07Reg:    .byte $2a,$07,28
                .byte "Space             Drop Piece"
Splash08Reg:    .byte $aa,$07,28
                .byte "P                 Pause Game"
Splash09Reg:    .byte $52,$04,30
                .byte "1                 Change Style!"
Splash10Reg:    .byte $d2,$04,27
                .byte "Esc               Quit Game"
Splash00b:      .byte $88,$05,22
                .byte "By Eric Sperano (2021)"
Splash02:       .byte $30,$04,22
                .byte "Keyboard Game Controls"
Splash11:       .byte $d8,$06,22
                .byte "Press Any Key To Start"
