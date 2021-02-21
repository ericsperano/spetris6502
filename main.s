; Spetris For the Apple ][+ and Apple //e Computers
; By Eric Sperano 2020-2021
;
; TODO use FLS (flashing text), and inv.. consider STR/REV too
; TODO Blinking game over (regular ascii)
; TODO Blinking Paused (regular ascii)
; TODO Blinking Press Any Key in splash screen (regular ascii)
; TODO non arrow key repeat
; TODO make slower for real apple ii!
                use macro/display
                use macro/init
                use macro/key
                use macro/ptr
                use macro/screen
                use macro/speed
                jsr SplashScreen                ; display screen and wait for a key press
                InitRandom                      ; generate some random numbers
                InitPtr PointsTable;PtrPoints   ; init constant zero page pointers
                InitPtr Field;PtrField
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
                bcs :drawNext                   ; it does, go on and draw next piece
                jmp GameOver                    ; it does not, game over!
:drawNext       jsr DrawNextPiece               ; draw the next piece
                bra :checkRefresh
roundLoop       jsr InitTryPieces
:checkRefresh   ldx FlagRefreshScr              ; check if we need to refresh the screen
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
                jmp :exitGame                   ; yes, exit game
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
                beq :endround                   ; no, go get next piece
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
:endround       jmp startRound
GameOver        jsr DrawField
                JSRDisplayStr NewGameL
]askNewGame     lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc ]askNewGame                 ; no, keep polling
                sta STROBE                      ; key pressed
                Check1Key KeyY;:doNewGame;:testKeyN
:doNewGame      jmp StartNewGame                ; yes, start new game
:testKeyN       Check1Key KeyN;:exitGame;]askNewGame
:exitGame       jsr HOME                        ; clear screen and exit
                AltCharSetOff
                rts
;
;
;
tmp1            dfb 0
tmp2            dfb 0
tmp3            dfb 0
LinesCount      dfb 0           ; lines count after lock piece
FlagForceDown   dfb 0
FlagRefreshScr  dfb 0
FlagFalling     dfb 0
FlagQuitGame    dfb 0
