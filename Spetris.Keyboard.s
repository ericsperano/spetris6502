***
***
***
KeyPressed      sta STROBE
                cmp #KeyUpArrow                 ; is it the up arrow key?
                bne testaKey                    ; no, keep searching
doUpKey         ldx PieceRot
                bne decRot
                ldx #3
                jmp storeRot
decRot          dex
storeRot        stx TryPieceRot
                jsr DoesPieceFit
                bcc endUpKey                    ; does not fit, return
                ldx TryPieceRot                 ; it fits, copy the new rotation value
                stx PieceRot
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endUpKey        rts
testaKey        cmp #Keya
                bne testAKey
                jmp doUpKey
testAKey        cmp #KeyA
                bne testLeftKey
                jmp doUpKey
testLeftKey     cmp #KeyLeftArrow               ; is it the left arrow key?
                bne testRightKey                ; no, keep searching
                dec TryPieceX                   ; yes, try with x - 1
                jsr DoesPieceFit
                bcc endLeftKey                  ; does not fit, return
                dec PieceX                      ; it fits, decrease x
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endLeftKey      rts
testRightKey    cmp #KeyRightArrow              ; is it the right arrow key?
                bne testDownKey                 ; no, keep searching
                inc TryPieceX                   ; yes, try with x + 1
                jsr DoesPieceFit
                bcc endRightKey                 ; does not fit, return
                inc PieceX                      ; it fits, increase x
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endRightKey     rts
testDownKey     cmp #KeyDownArrow               ; is it the down arrow key?
                bne testzKey                    ; no, keep searching
                 ; TODO reset the forcedown
doDownKey       inc TryPieceY                   ; yes, try with y + 1
                jsr DoesPieceFit
                bcc endDownKey                  ; does not fit, return
                inc PieceY                      ; it fits, increase y
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endDownKey      rts
testzKey        cmp #Keyz
                bne testZKey
                jmp doDownKey
testZKey        cmp #KeyZ
                bne testSpaceKey
                jmp doDownKey
testSpaceKey    cmp #KeySpace                   ; is it the space bar?
                bne testEscKey                  ; no keep searching
                ldx #1                          ;
                stx FlagForceDown
                stx FlagFalling
testEscKey      cmp #KeyEscape                  ; is it the escape key?
                bne testpKey                    ; no, keep searching
                ldx #1                          ; yes, quit the game
                stx FlagQuitGame
endEscKey       rts
testpKey        cmp #Keyp                       ; is it the P key?
                bne testPKey                    ; no, return
doPKey          JSRDisplayStr PausedL           ; yes, display pause message
pauseLoop       lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc pauseLoop                   ; no, keep polling
                sta STROBE                      ; key pressed
                JSRDisplayStr PausedBlankL      ; erase pause msg and return
testPKey        cmp #KeyP                       ; is it the P key?
                bne test1Key                    ; no, return
                jmp doPKey
test1Key        cmp #Key1
                bne end1Key
                ldx CurrCharset
                lda FlagMouseText
                beq testRegChSet0
                cpx #0
                bne testMTChSet1
                inx                             ; curr char set is 0, inc to 1
                jsr UseMT2Charset
                jmp convField
testMTChSet1    cpx #1
                bne testMTChSet2
                inx
                jsr UseRegCharset
                jmp convField
testMTChSet2    cpx #2
                bne testMTChSet3
                inx
                jsr UseReg2Charset
                jmp convField
testMTChSet3    ldx #0
                jsr UseMTCharset
                jmp convField
testRegChSet0   cpx #0
                bne testRegChSet1
                inx                             ; curr char set is 0, inc to 1
                jsr UseReg2Charset
                jmp convField
testRegChSet1   ldx #0
                jsr UseRegCharset
convField       stx CurrCharset
                jsr ConvertField
                jsr DrawField
                jsr DrawPiece
end1Key         rts
***
***
***
KeyLeftArrow    equ $88
KeyRightArrow   equ $95
KeyUpArrow      equ $8b
KeyDownArrow    equ $8a
KeySpace        equ $a0
KeyEscape       equ $9b
Key1            equ "1"
Key2            equ "2"
Keya            equ "a"
KeyA            equ "A"
Keyp            equ "p"
KeyP            equ "P"
Keyz            equ "z"
KeyZ            equ "Z"
