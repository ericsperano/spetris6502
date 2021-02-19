;
;
;
KeyPressed      sta STROBE
                cmp #KeyUpArrow                 ; is it the up arrow key?
                bne testhKey                    ; no, keep searching
doUpKey         ldx PieceRot
                bne decRot
                ldx #3
                bra storeRot
decRot          dex
storeRot        stx TryPieceRot
                jsr DoesPieceFit
                bcc endUpKey                    ; does not fit, return
                ldx TryPieceRot                 ; it fits, copy the new rotation value
                stx PieceRot
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endUpKey        rts
testhKey        cmp #Keyh
                bne testHKey
                bra doUpKey
testHKey        cmp #KeyH
                bne testLeftKey
                bra doUpKey
testLeftKey     cmp #KeyLeftArrow               ; is it the left arrow key?
                bne testbKey                    ; no, keep searching
doLeftKey       dec TryPieceX                   ; yes, try with x - 1
                jsr DoesPieceFit
                bcc endLeftKey                  ; does not fit, return
                dec PieceX                      ; it fits, decrease x
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endLeftKey      rts
testbKey        cmp #Keyb
                bne testBKey
                bra doLeftKey
testBKey        cmp #KeyB
                bne testRightKey
                bra doLeftKey
testRightKey    cmp #KeyRightArrow              ; is it the right arrow key?
                bne testmKey                     ; no, keep searching
doRightKey      inc TryPieceX                   ; yes, try with x + 1
                jsr DoesPieceFit
                bcc endRightKey                 ; does not fit, return
                inc PieceX                      ; it fits, increase x
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endRightKey     rts
testmKey        cmp #Keym
                bne testMKey
                bra doRightKey
testMKey        cmp #KeyM
                bne testDownKey
                bra doRightKey
testDownKey     cmp #KeyDownArrow               ; is it the down arrow key?
                bne testnKey                    ; no, keep searching
                 ; TODO reset the forcedown
doDownKey       inc TryPieceY                   ; yes, try with y + 1
                jsr DoesPieceFit
                bcc endDownKey                  ; does not fit, return
                inc PieceY                      ; it fits, increase y
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endDownKey      rts
testnKey        cmp #Keyn
                bne testNKey
                bra doDownKey
testNKey        cmp #KeyN
                bne testSpaceKey
                bra doDownKey
testSpaceKey    cmp #KeySpace                   ; is it the space bar?
                bne testEscKey                  ; no keep searching
                ldx #1                          ;
                stx FlagForceDown
                stx FlagFalling
                stx FlagRefreshScr
                bra end1Key
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
                bra doPKey
test1Key        cmp #Key1
                bne end1Key
                ldx TilesetID
                inx
                cpx #TotalTilesets
                bne :savetid
                ldx #0
:savetid        stx TilesetID
                jsr UseTileset
                jsr ConvertField
                jsr DrawField
                jsr DrawPiece
end1Key         rts
;
;
;
