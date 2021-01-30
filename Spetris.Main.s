***
*** SPETRIS FOR THE APPLE II COMPUTER
***
                org $2000
                use macro/InitPtr.Macs
                use macro/JSRDisplayBCD.Macs
                use macro/JSRDisplayStr.Macs
                * begin program
                jsr SplashScreen                ; display screen and wait for a key press
                jsr HOME                        ; clear screen
                DO ]USE_EXT_CHAR
                sta ALTCHARSETON                ; enable alternate char set
                FIN
                * init constant zero page pointers
                InitPtr PointsTable;PTR_Points
                InitPtr Field;PTR_Field
                jsr InitRandom                  ; generate some random numbers ; TODO use or Macro?
                jsr NewGame                     ; initialize new game           ; TODO use or Macro?
                JSRDisplayStr Title             ; display all the right side lables
                JSRDisplayStr HighScoreL
                JSRDisplayBCD HighScore
                JSRDisplayStr ScoreL
                JSRDisplayBCD Score
                JSRDisplayStr LevelL
                JSRDisplayBCD LevelBCD
                JSRDisplayStr TotalPiecesL
                JSRDisplayBCD TotalPiecesBCD
                JSRDisplayStr NextPieceL
                jsr NewPiece                    ; get 2 new piece at the start (current and next)
startRound      jsr NewPiece                    ; initialize this round
                jsr DrawNextPiece               ; draw the new next piece
                jsr InitTryPieces
                jsr DoesPieceFit                ; first check if it would fit
                bcs roundLoop2                  ; it does, go on with the loop for this round
                jmp endGame                     ; it does not, game over!
roundLoop       jsr InitTryPieces
roundLoop2      ldx FlagRefreshScr
                beq roundSleep
                jsr DrawField
                jsr DrawPiece
                dec FlagRefreshScr              ; clear the refresh screen flag
roundSleep      ldx FlagFalling                 ; is it falling?
                beq roundSleep1                 ; no, go sleep
                stx FlagForceDown               ; yes, will force down and refresh screen
                stx FlagRefreshScr
roundSleep1     jsr Sleep
                clc
                *inc SpeedCount                  ; increment the speed count
                lda SpeedCountLo
                adc #1
                sta SpeedCountLo
                lda SpeedCountHi
                adc #0
                sta SpeedCountHi
                * 16 bits comparisons of Speed and SpeedCount
                lda SpeedCountHi
                cmp SpeedHi
                bcc pollKeyboard                ;X < Y
                lda SpeedCountLo
                cmp SpeedLo
                bcc pollKeyboard
                ldx #1                          ; we reached speed max
                stx FlagForceDown               ; yes, will force down and refresh screen
                stx FlagRefreshScr
                dex
                stx SpeedCountLo                ; reset the speed counter
                stx SpeedCountHi
pollKeyboard    lda KYBD                        ; polls keyboard
                cmp #$80
                bcc chkForceDown                ; no key pressed
                jsr KeyPressed                  ; go handle key pressed
                ldx FlagQuitGame                ; esc pressed?
                beq chkForceDown                ; no, go on
                jmp exitGame                    ; yes, exit game
chkForceDown    ldx FlagForceDown               ; is it time for piece to go down?
                bne moveDown
                jmp roundLoop                   ; no
moveDown        jsr InitTryPieces
                inc TryPieceY                   ; check if it can go further down
                jsr DoesPieceFit
                bcc roundLockPiece              ; it doesnt, we lock
                inc PieceY
                dec FlagForceDown               ; clear the flag
                jmp roundLoop
roundLockPiece  jsr LockPiece                   ; lock the piece into field
                jsr CheckForLines               ; check if it has complete lines
                jsr IncScore
                JSRDisplayBCD Score
                JSRDisplayBCD HighScore
                jsr IncTotalPieces
                JSRDisplayBCD TotalPiecesBCD
                ldx LinesCount
                beq endRound                    ; no, go get next piece
                jsr DrawField                   ; yep, draw and sleep for animation
                ldx #SleepTime
loopSleep       jsr Sleep
                dex
                bne loopSleep
                jsr RemoveLines                 ; animation displayed, remove the lines from the field
                ldx #1
                stx FlagRefreshScr
endRound        jmp startRound
***
***
***
KeyPressed      sta STROBE
                cmp #KeyUpArrow                 ; is it the up arrow key?
                bne testLeftKey                 ; no, keep searching
                ldx PieceRot
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
                 ; TODO reset the forcedown
                bne testSpaceKey                ; no, keep searching
                inc TryPieceY                   ; yes, try with y + 1
                jsr DoesPieceFit
                bcc endDownKey                  ; does not fit, return
                inc PieceY                      ; it fits, increase y
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
endDownKey      rts
testSpaceKey    cmp #KeySpace                   ; is it the space bar?
                bne testEscKey                  ; no keep searching
                ldx #1                          ;
                stx FlagForceDown
                stx FlagFalling
testEscKey      cmp #KeyEscape                  ; is it the escape key?
                bne testPKey                    ; no, keep searching
                ldx #1                          ; yes, quit the game
                stx FlagQuitGame
endEscKey       rts
testPKey        cmp #KeyP                       ; is it the P key?
                bne endPKey                     ; no, return
                JSRDisplayStr PausedL           ; yes, display pause message
pauseLoop       lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc pauseLoop                   ; no, keep polling
                sta STROBE                      ; key pressed
                JSRDisplayStr PausedBlankL      ; erase pause msg and return
endPKey         rts
***
***
endGame         nop
exitGame        jsr HOME
                rts
***
***
***
NewGame         lda #0
                sta FlagQuitGame
                sta SpeedCountLo
                sta SpeedCountHi
                sta ScoreBCD
                sta ScoreBCD+1
                sta ScoreBCD+2
                sta ScoreBCD+3
                lda #$ff
                sta SpeedLo
                lda #5
                sta SpeedHi
                lda #1
                sta FlagRefreshScr
                sta Level
                rts
***
*** SetScreenPos
*** Set PTR_ScreenPos with register x,y
***
SetScreenPos    phy
                phx
                tya
                asl ; multiply by 2 because each array elem is 2 bytes (an address)
                tay
                stx SSP_X
                InitPtr FieldPositions;PTR_FieldPos
                clc
                lda (PTR_FieldPos),y
                adc SSP_X
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                *adc #0   ; negative numbers set the carry bit
                sta PTR_ScreenPos+1
                plx
                ply
                rts
*
SSP_X           dfb 0 ; to rename X tmp

SetFieldPos     phy
                stx SSP_X
                InitPtr Field;PTR_Field
                cpy #0
                beq SFP_End
SFP_loop0       lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                dey
                bne SFP_loop0
SFP_End         lda PTR_Field
                clc
                adc SSP_X
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                ply
                rts
***
*** Draw Field
***
DrawField       InitPtr Field;PTR_Field
                InitPtr FieldPositions;PTR_FieldPos
                ldy #0
                ldx #0 ; row counter
                sty DF_FieldPosY
                * initialize the screen pointer
DF_Loop1        ldy DF_FieldPosY
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos+1
                iny
                sty DF_FieldPosY ; save y for field pos
                ldy #0
DF_Loop0        lda (PTR_Field),y
                sta (PTR_ScreenPos),y
                iny
                cpy #FieldCols
                bne DF_Loop0
                inx
                cpx #FieldRows
                beq DF_End
                clc                              ; clear carry flag
                lda PTR_Field         ; add 3 to lo byte of struct pointer to point to text to print
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                jmp DF_Loop1
DF_End          rts
*
DF_FieldPosY    dfb 0
***
***  DoesPieceFit
***
***  Returns:
***    Carry flag on/off: Piece fits/doesn't fit
***
DoesPieceFit    ldx TryPieceX
                ldy TryPieceY
                jsr SetFieldPos
                lda TryPieceRot ; set ptr piece expects rotation in register a
                ldx PieceId
                jsr SetPtrPiece ;
                ldx #4
dpfLoop1        ldy #0
dpfLoop0        lda (PTR_Piece),y
                cmp #'.'
                beq dpfNextCh
                * pixel is on, need to check if it's empty in the field
                lda (PTR_Field),y
                cmp #" "
                beq dpfNextCh
                clc                             ; clear carry and return, does not fit
                rts
dpfNextCh       iny
                cpy #4
                bne dpfLoop0
                * increment ptr_piece by 4
                lda PTR_Piece
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                * increment FieldPos by FieldCols
                lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                dex
                bne dpfLoop1
                sec                             ; set carry and return, piece fits
                rts
***
***
***
LockPiece       ldx PieceX
                ldy PieceY
                jsr SetFieldPos
                lda PieceRot ; set ptr piece expects rotation in register a
                ldx PieceId
                jsr SetPtrPiece ;
                ldx #4
lpLoop1         ldy #0
lpLoop0         lda (PTR_Piece),y
                cmp #'.'
                beq lpNextCh
                * pixel is on, lock it on field
                lda #ChTile
                sta (PTR_Field),y
lpNextCh        iny
                cpy #4
                bne lpLoop0
                * increment ptr_piece by 4
                lda PTR_Piece
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                * increment FieldPos by FieldCols
                lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                dex
                bne lpLoop1
                rts
***
*** CheckForLines: goes through the field and check if there are any full lines
*** this routine also updates the score by at least 25pts (we are called because a piece is locked)
*** and by (1 << nblines) * 100
***
CheckForLines   lda #0
                sta LinesCount                  ; clear the lines count
                InitPtr Field;PTR_Field
                ldx #16
cflCheckRow     ldy #2                          ; start at pos 2 in the row
cflLoop0        lda (PTR_Field),y
                cmp #" "                        ; is it a space? TODO constant
                beq cflNextRow                  ; yeah so not a line, look next row
                iny                             ; no, keep looking previous char on row
                cpy #12                         ; loop if we haven't reach the right side
                bcc cflLoop0
                inc LinesCount
                ldy #2                          ; mark the line in the field for display
                lda #ChLines                    ; by using the line char
cflLoop1        sta (PTR_Field),y
                iny
                cpy #12                         ; loop if we haven't reach the right side
                bcc cflLoop1
cflNextRow      dex
                beq cflEnd
                lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                jmp cflCheckRow
cflEnd          rts
***
*** RemoveLines
***
RemoveLines     lda #<FieldBottom               ; start from the bottom
                sta PTR_Field                   ; save lo byte
                lda #>FieldBottom
                sta PTR_Field+1                 ; save hi byte
rlLoop0         ldy #2                          ; start at pos 2 in the row
                lda (PTR_Field),y
                cmp #ChLines                    ; is third char a line indicator?
                bne rlUp                        ; no, skip
                * move rows
                lda PTR_Field+1                 ; copy current pointer hi byte to tmp1
                sta PTR_FieldTmp1+1
                lda PTR_Field                   ; copy current pointer lo byte to tmp1
                sta PTR_FieldTmp1
rlLoop1         sec                             ; set pointer tmp2 above current line
                sbc #FieldCols                  ; substract length of row from lo byte
                sta PTR_FieldTmp2
                lda PTR_FieldTmp1+1
                sbc #0                          ; substract carry from hi byte
                sta PTR_FieldTmp2+1
                cmp #>Field                     ; check if previous line is lower memory adr than beginning of field
                bcc rlEnd                       ; hi byte is lower yes, end
                bne rlCopy                      ; hi byte is not equal
                lda PTR_FieldTmp2               ; check lo byte
                cmp #<Field
                beq rlEnd                       ; yes, end
rlCopy          ldy #2
rlCopyLoop      lda (PTR_FieldTmp2),y           ; copy previous line
                sta (PTR_FieldTmp1),y
                iny
                cpy #12
                bne rlCopyLoop
                lda PTR_FieldTmp2+1
                sta PTR_FieldTmp1+1
                lda PTR_FieldTmp2
                sta PTR_FieldTmp1
                jmp rlLoop1
rlUp            sec                             ; go up one row
                lda PTR_Field
                sbc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                sbc #0
                sta PTR_Field+1
                * check if we are at top
rlEnd           lda PTR_Field+1
                cmp #>Field
                bne rlLoop0                     ; no, check previous line
                lda PTR_Field
                cmp #<Field
                bne rlLoop0                     ; no, check previous line
                rts
***
***
***
FieldCols      equ 14
FieldRows      equ 17
*Field           ds  160,$a0
* total field size is 14*17=238 so we can use an 8bit index
                DO ]USE_EXT_CHAR
LBR             equ $5a
RBR             equ $5f
LCR             equ " "
RCR             equ " "
BBR             equ $4c
                ELSE
LBR             equ $20
RBR             equ $20
LCR             equ $20
RCR             equ $20
BBR             equ $20
                FIN
Field           dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
FieldBottom     dfb $a0,LBR,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,RBR,$a0
                dfb $a0,LCR,BBR,BBR,BBR,BBR,BBR,BBR,BBR,BBR,BBR,BBR,RCR,$a0
FieldPositions  dfb $80,$05
                dfb $00,$06
                dfb $80,$06
                dfb $00,$07
                dfb $80,$07
                dfb $28,$04
                dfb $a8,$04
                dfb $28,$05
                dfb $a8,$05
                dfb $28,$06
                dfb $a8,$06
                dfb $28,$07
                dfb $a8,$07
                dfb $50,$04
                dfb $d0,$04
                dfb $50,$05
                dfb $d0,$05
*
*
Title           dfb $93,$05,16
                DO ]USE_EXT_CHAR
                asc "S P E T R // S !"
                ELSE
                asc "S P E T R ][ S !"
                FIN
LevelL          dfb $90,$07,6
                asc "Level:"
PausedL         dfb $de,$06,11
                asc "P A U S E D"
PausedBlankL    dfb $de,$06,11
                asc "           "

SpeedCountLo    dfb 0
SpeedCountHi    dfb 0
SpeedLo         dfb 0
SpeedHi         dfb 0
LinesCount      dfb 0
FlagForceDown   dfb 0
FlagRefreshScr  dfb 0
FlagFalling     dfb 0
FlagQuitGame    dfb 0
LevelBCD        dfb $a3,$07,$01
Level           dfb $00
PointsTable     dfb $00,$25,$02,$25,$04,$25,$08,$25,$16,$25 ; points for 0 to 4 lines, 2 bytes bcd
***
*** zero page pointers
***
PTR_FieldTmp1   equ $06
PTR_FieldTmp2   equ $08
PTR_Points      equ $1d
PTR_Piece       equ $ce
PTR_Field       equ $eb
PTR_FieldPos    equ $ed
PTR_ScreenPos   equ $fa
PtrDisplayStr   equ $fc         ; used by the DisplayStr routine
***
*** Game constants
***
SleepTime       equ $ff
ChTransparent   equ '.'
                DO ]USE_EXT_CHAR
ChTile          equ $7f
ChLines         equ $ff
                ELSE
ChTile          equ $23
ChLines         equ "-"
                FIN
KeyLeftArrow    equ $88
KeyRightArrow   equ $95
KeyUpArrow      equ $8b
KeyDownArrow    equ $8a
KeySpace        equ $a0
KeyEscape       equ $9b
KeyP            equ "p"
***
*** Apple II Subroutines
***
KYBD            equ $c000
STROBE          equ $c010
HOME            equ $fc58
ALTCHARSETON    equ $c00f
*ALTCHARSETOFF   equ $c00e