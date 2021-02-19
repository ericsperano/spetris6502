; Spetris For the Apple ][+ and Apple //e Computers
; By Eric Sperano 2020-2021
;
; TODO use FLS (flashing text), and REV.. consider STR too
; TODO Blinking game over (regular ascii)
; TODO Blinking Paused (regular ascii)
; TODO Blinking Press Any Key in splash screen (regular ascii)
;
                use macro/display
                use macro/init
                use macro/ptr
                use macro/screen
                use macro/speed
                jsr SplashScreen                ; display screen and wait for a key press
                InitRandom                      ; generate some random numbers
                InitPtr PointsTable;PtrPoints   ; init constant zero page pointers
                InitPtr Field;PTR_Field
StartNewGame    jsr HOME                        ; clear screen
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
startRound      jsr NewPiece                    ; initialize this round
                lda #0                          ; reset SpeedCount
                sta SpeedCount+1
                sta SpeedCount
                jsr InitTryPieces
                jsr DoesPieceFit                ; first check if it would fit
                bcs roundLoop2                  ; it does, go on with the loop for this round
                jmp GameOver                    ; it does not, game over!
roundLoop       jsr InitTryPieces
roundLoop2      jsr DrawNextPiece               ; draw the next piece once we know the current one fits
                ldx FlagRefreshScr              ; check if we need to refresh the screen
                beq checkFalling                ; no, go sleep a little
                jsr DrawField                   ; refresh the screen
                jsr DrawPiece
                dec FlagRefreshScr              ; clear the refresh screen flag
checkFalling    ldx FlagFalling                 ; is it falling?
                beq roundSleep                  ; no, go sleep
                stx FlagForceDown               ; yes, will force down and refresh screen
                stx FlagRefreshScr
roundSleep      jsr Sleep
                IncSpeedCount pollKeyboard      ; incr speed. set FlagForceDown to true if it reach limit
pollKeyboard    lda KYBD                        ; polls keyboard
                cmp #$80
                bcc chkForceDown                ; no key pressed, go check force down flag
                jsr KeyPressed                  ; go handle key pressed
                ldx FlagQuitGame                ; esc pressed?
                beq chkForceDown                ; no, go on
                jmp exitGame                    ; yes, exit game
chkForceDown    ldx FlagForceDown               ; is it time for piece to go down?
                bne moveDown                    ; yes
                bra roundLoop                   ; no, loop
moveDown        dec FlagForceDown               ; clear the flag
                jsr InitTryPieces               ; ok, time to move the piece down
                inc TryPieceY                   ; first, check if it can go further down
                jsr DoesPieceFit
                bcc roundLockPiece              ; it doesnt, we lock
                inc PieceY
                bra roundLoop
roundLockPiece  jsr LockPiece                   ; lock the piece into field
                jsr CheckForLines               ; check if it has complete lines
                jsr IncScore
                JSRDisplayBCD Score
                JSRDisplayBCD HighScore
                jsr IncTotalPieces              ; increment total piece count
                JSRDisplayBCD TotalPieces
                ldx LinesCount                  ; did we get any lines?
                beq endRound                    ; no, go get next piece
                jsr CheckLevel                  ; go check level
                JSRDisplayBCD Level             ; refresh level and total lines display
                JSRDisplayBCD TotalLines
                jsr DrawField                   ; yes, draw and sleep for animation
                jsr PointsSounds
                ldx #SleepTime
]sleep          jsr Sleep
                dex
                bne ]sleep
                jsr RemoveLines                 ; animation displayed, remove the lines from the field
                ldx #1
                stx FlagRefreshScr
endRound        jmp startRound
GameOver        jsr DrawField
                JSRDisplayStr NewGameL
]askNewGame     lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc ]askNewGame                 ; no, keep polling
                sta STROBE                      ; key pressed
                cmp #Keyy                       ; check lower case y
                bne :testKeyY                   ; no, keep checking
                jmp StartNewGame                ; yes, start new game
:testKeyY       cmp #KeyY                       ; check upper case Y
                bne :testKeyn                   ; no, keep checking
                jmp StartNewGame                ; yes, start new game
:testKeyn       cmp #Keyn                       ; check lower case n
                bne :testKeyN                   ; no, keep checking
                bra exitGame                    ; yes, exit game
:testKeyN       cmp #KeyN                       ; check upper case n
                bne ]askNewGame                 ; no, loop
exitGame        jsr HOME                        ; clear screen and exit
                rts
;
;
;
LinesCount      dfb 0           ; lines count after lock piece
FlagForceDown   dfb 0
FlagRefreshScr  dfb 0
FlagFalling     dfb 0
FlagQuitGame    dfb 0