;
;
;
KeyPressed      sta STROBE
; Up Key ?
                Check2Keys KeyUpArrow;KeyA;:doUp;:testLeft
:doUp           ldx PieceRot
                bne :decr
                ldx #3
                bra :store
:decr           dex
:store          stx TryPieceRot
                jsr DoesPieceFit
                bcc :endUpKey                   ; does not fit, return
                ldx TryPieceRot                 ; it fits, copy the new rotation value
                stx PieceRot
                SetFlagRefresh                  ; and refresh screen
:endUpKey       rts
; Left Key ?
:testLeft       cmp #KeyLeftArrow
                bne :testRight
:doLeft         dec TryPieceX                   ; try with x - 1
                jsr DoesPieceFit
                bcc :endLeftKey                 ; does not fit, return
                dec PieceX                      ; it fits, decrease x
                SetFlagRefresh                  ; and refresh screen
:endLeftKey     rts
; Right Key ?
:testRight      cmp #KeyRightArrow
                bne :testDown
:doRight        inc TryPieceX                   ; try with x + 1
                jsr DoesPieceFit
                bcc :endRightKey                ; does not fit, return
                inc PieceX                      ; it fits, increase x
                SetFlagRefresh                  ; and refresh screen
:endRightKey    rts
; Down Key ?
:testDown       Check2Keys KeyDownArrow;KeyZ;:doDown;:testSpace
:doDown         inc TryPieceY                   ; try with y + 1
                jsr DoesPieceFit
                bcc :endDownKey                 ; does not fit, return
                inc PieceY                      ; it fits, increase y
                SetFlagRefresh                  ; and refresh screen
:endDownKey     rts
; Space Key ?
:testSpace      cmp #KeySpace                   ; is it the space bar?
                bne :testQ                      ; no keep searching
                ldx #1                          ;
                stx FlagForceDown
                stx FlagFalling
                stx FlagRefreshScr
                rts
; Q Key ?
:testQ          cmp #KeyQ                       ; is it the escape key?
                bne :testP                      ; no keep searching
                ldx #1                          ; yes, quit the game
                stx FlagQuitGame
                rts
; P Key ?
:testP          Check1Key KeyP;:doP;:testtab
:doP            JSRDisplayStr PausedL           ; display pause message
]loop           lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc ]loop                       ; no, keep polling
                sta STROBE                      ; key pressed
                JSRDisplayStr PausedBlankL      ; erase pause msg and return
                rts
; Tab Key ?
:testtab        cmp #KeyTab
                bne :endTabKey
                ldx TilesetID                   ; increment tileset id
                inx
                cpx #TotalTilesets              ; reset if overflow
                bne :savetid
                ldx #0
:savetid        stx TilesetID                   ; save tileset id
                jsr UseTileset                  ; update tileset structure
                jsr ConvertField                ; convert the field to new tileset
                jsr DrawField                   ; redraw field
                jsr DrawPiece                   ; redraw piece
                jsr DrawNextPiece               ; as well as next piece
:endTabKey        rts
