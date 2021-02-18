;***
;*** SPETRIS FOR THE APPLE II COMPUTER
;***
;*** BUG  New Piece does not always show up?? can't reproduce how...
;***
;*** TODO No phx,plx,phy,ply, etc on old Apple II
;*** TODO confirm quit on escape key
;*** TODO make it work in DOS 3.3
;*** TODO Sound
;*** TODO use an array of structs for charsets
;*** TODO Blinking game over (regular ascii)
;*** TODO Blinking Paused (regular ascii)
;*** TODO Blinking Press Any Key in splash screen (regular ascii)
;***
                .include "macro/IncSpeedCount.Macs.s"
                .include "macro/InitGame.Macs.s"
                .include "macro/InitPtr.Macs.s"
                .include "macro/InitRandom.Macs.s"
                .include "macro/JSRDisplayBCD.Macs.s"
                .include "macro/JSRDisplayStr.Macs.s"
                jsr MenuCharset                 ; ask which charset to use
                jsr SplashScreen                ; display screen and wait for a key press
                InitRandom                      ; generate some random numbers
                InitPtr PointsTable,PTR_Points  ; init constant zero page pointers
                InitPtr Field,PTR_Field
StartNewGame:   jsr HOME                        ; clear screen
                sta ALTCHARSETON                ; enable alternate char set
                InitGame                        ; initialize new game
                jsr InitField                   ; initialize clean field
                JSRDisplayStr Title             ; display all the right side labels
                JSRDisplayStr HighScoreL
                JSRDisplayBCD HighScore
                JSRDisplayStr ScoreL
                JSRDisplayBCD Score
                JSRDisplayStr LevelL
                JSRDisplayBCD Level
                JSRDisplayStr TotalPiecesL
                JSRDisplayBCD TotalPieces
                JSRDisplayStr TotalLinesL
                JSRDisplayBCD TotalLines
                JSRDisplayStr NextPieceL
                jsr NewPiece                    ; get 2 new piece at the start (current and next)
startRound:     jsr NewPiece                    ; initialize this round
                lda #0                          ; reset SpeedCount
                sta SpeedCount+1
                sta SpeedCount
                jsr InitTryPieces
                jsr DoesPieceFit                ; first check if it would fit
                bcs roundLoop2                  ; it does, go on with the loop for this round
                jmp GameOver                    ; it does not, game over!
roundLoop:      jsr InitTryPieces
roundLoop2:     jsr DrawNextPiece               ; draw the next piece once we know the current one fits
                ldx FlagRefreshScr              ; check if we need to refresh the screen
                beq checkFalling                ; no, go sleep a little
                jsr DrawField                   ; refresh the screen
                jsr DrawPiece
                dec FlagRefreshScr              ; clear the refresh screen flag
checkFalling:   ldx FlagFalling                 ; is it falling?
                beq roundSleep                  ; no, go sleep
                stx FlagForceDown               ; yes, will force down and refresh screen
                stx FlagRefreshScr
roundSleep:     jsr Sleep
                IncSpeedCount pollKeyboard      ; incr speed. set FlagForceDown to true if it reach limit
pollKeyboard:   lda KYBD                        ; polls keyboard
                cmp #$80
                bcc chkForceDown                ; no key pressed, go check force down flag
                jsr KeyPressed                  ; go handle key pressed
                ldx FlagQuitGame                ; esc pressed?
                beq chkForceDown                ; no, go on
                jmp exitGame                    ; yes, exit game
chkForceDown:   ldx FlagForceDown               ; is it time for piece to go down?
                bne moveDown                    ; yes
                jmp roundLoop                   ; no, loop
moveDown:       dec FlagForceDown               ; clear the flag
                jsr InitTryPieces               ; ok, time to move the piece down
                inc TryPieceY                   ; first, check if it can go further down
                jsr DoesPieceFit
                bcc roundLockPiece              ; it doesnt, we lock
                inc PieceY
                jmp roundLoop
roundLockPiece: jsr LockPiece                   ; lock the piece into field
                jsr CheckForLines               ; check if it has complete lines
                jsr IncScore
                JSRDisplayBCD Score
                JSRDisplayBCD HighScore
                jsr IncTotalPieces              ; increment total piece count
                JSRDisplayBCD TotalPieces
                ldx LinesCount
                beq endRound                    ; no, go get next piece
                jsr CheckLevel                  ; go check level
                JSRDisplayBCD Level             ; refresh level and total lines display
                JSRDisplayBCD TotalLines
                jsr DrawField                   ; yes, draw and sleep for animation
                ldx #SleepTime
loopSleep:      jsr Sleep
                dex
                bne loopSleep
                jsr RemoveLines                 ; animation displayed, remove the lines from the field
                ldx #1
                stx FlagRefreshScr
endRound:       jmp startRound
GameOver:       jsr DrawField
                JSRDisplayStr NewGameL
askNewGameLoop: lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc askNewGameLoop              ; no, keep polling
                sta STROBE                      ; key pressed
                ; TODO check uppercase!
                cmp #ASCII_y
                bne testNewGameN
                jmp StartNewGame
testNewGameN:   cmp #ASCII_n
                bne askNewGameLoop
exitGame:       jsr HOME
                rts
;
;
;
LinesCount:     .byte 0           ; lines count after lock piece
FlagForceDown:  .byte 0
FlagRefreshScr: .byte 0
FlagFalling:    .byte 0
FlagQuitGame:   .byte 0
FlagMouseText:  .byte 0
;***
;*** zero page pointers
;***
PTR_FieldTmp1   = $06
PTR_FieldTmp2   = $08
PTR_Points      = $1d
PTR_Piece       = $ce
PTR_Field       = $eb
PTR_FieldPos    = $ed
PTR_ScreenPos   = $fa
PtrDisplayStr   = $fc         ; used by the DisplayStr routine
;***
;*** Apple II Subroutines
;***
KYBD            = $c000
STROBE          = $c010
HOME            = $fc58
ALTCHARSETON    = $c00f
ALTCHARSETOFF   = $c00e
