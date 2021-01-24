***
*** SPETRIS FOR THE APPLE II COMPUTER
***
                org $2000
                use macro/DisplayLine.Macs
                use macro/InitPtr.Macs
                * begin program
                jsr SplashScreen                ; display screen and wait for a key press
                jsr HOME                        ; clear screen
                sta ALTCHARSETON                ; enable alternate char set
                * init zero page pointers
                InitPtr PointsTable;PTR_Points
                InitPtr Field;PTR_Field
                * draw screen
                JSRDisplayLine Title            ; display all the right side lables
                JSRDisplayLine HighScoreL
                JSRDisplayLine ScoreL
                JSRDisplayLine LevelL
                JSRDisplayLine TotalPiecesL
                JSRDisplayLine NextPieceL
                jsr DisplayScore
                jsr DisplayHiScore
                jsr InitRandom                  ; generate some random numbers
                * start a new game
startGame       jsr NewGame                     ; initialize new game
                jsr NewPiece                    ; get 2 new piece at the start (current and next)
startRound      jsr NewPiece                    ; initialize this round
                jsr DrawNextPiece               ; draw the new next piece
                jsr CopyPieces
                jsr DoesPieceFit                ; first check if it would fit
                bcs roundLoop2                  ; it does, go on with the loop for this round
                jmp endGame                     ; it does not, game over!
roundLoop       jsr CopyPieces
roundLoop2      ldx FlagRefreshScr
                beq roundSleep
                jsr DrawField
                jsr DrawPiece
                ; draw scores
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
moveDown        jsr CopyPieces
                inc TryPieceY                   ; check if it can go further down
                jsr DoesPieceFit
                bcc roundLockPiece              ; it doesnt, we lock
                *ldx FlagPieceFits
                *beq roundLockPiece              ; it doesnt, we lock
                inc PieceY
                dec FlagForceDown               ; clear the flag
                jmp roundLoop
roundLockPiece  jsr LockPiece                   ; lock the piece into field
                jsr CheckForLines               ; check if it has complete lines
                jsr IncScore
                jsr DisplayScore
                jsr DisplayHiScore
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
                JSRDisplayLine PausedL          ; yes, display pause message
pauseLoop       lda KYBD                        ; poll keyboard
                cmp #$80                        ; key pressed?
                bcc pauseLoop                   ; no, keep polling
                sta STROBE                      ; key pressed
                JSRDisplayLine PausedBlankL     ; erase pause msg and return
endPKey         rts
***
***
endGame         nop
exitGame        jsr HOME
                rts
***
***
***

***
***
***
NewGame         lda #0
                sta FlagQuitGame
                sta SpeedCountLo
                sta SpeedCountHi
                sta Score
                sta Score+1
                sta Score+2
                sta Score+3
                sta Score+4
                lda #$ff
                sta SpeedLo
                lda #5
                sta SpeedHi
                lda #1
                sta FlagRefreshScr
                rts
NewPiece        lda #0
                sta PieceY
                sta PieceRot
                sta FlagFalling
                lda #5
                sta PieceX
                lda NextPieceId
                sta PieceId
npRand          jsr RandomNumber
                lda Rand1
                and #%00000111
                cmp #7
                beq npRand
                sta NextPieceId
                rts
***
*** Set PTR_Piece
**  A=rotation
**  X=pieceID
**  Trashes A,X
***
SetPtrPiece     pha                             ; save rotation on stack
                lda #<Pieces                    ; lo byte of struct to display
                sta PTR_Piece
                lda #>Pieces                    ; hi byte of struct to display
                sta PTR_Piece+1
                *ldx PieceId
                cpx #0
                beq SPP_testRot
SPP_loop0       clc
                lda PTR_Piece
                adc #PieceStructLen
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                dex
                bne SPP_loop0
SPP_testRot     pla ; take rotation from stack
                tax
                ;ldx PieceRot
                beq SPP_End
SPP_loop1       clc
                lda PTR_Piece
                adc #PieceLen
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                dex
                bne SPP_loop1
SPP_End         rts
***
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
                adc #0
                sta PTR_ScreenPos+1
                plx
                ply
                rts
* this is like SetScreenPos but doesn't do the add carry because of negative number that sets it....
* and we don't actually need to adc since it will never be more than + 10
SetScreenPos2   phy
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

SetFieldPos2    phy
                stx SSP_X
                InitPtr Field;PTR_Field
                cpy #0
                beq SFP_End
SFP_loop0       lda PTR_Field
                clc
                adc #FIELD_COLS
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
*** Draw Piece
***
DrawPiece       lda PieceRot
                ldx PieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx DP_Rows
                ldy PieceY      ; use a copy of PieceY (DP_Y) to not increment the real variable
                sty DP_Y
dpLoop1         ldy DP_Y
                ldx PieceX
                jsr SetScreenPos2
                ldy #0
dploop0         lda (PTR_Piece),y
                cmp #ChTransparent
                beq dpNextCh
                lda #$7f       ; TODO constant
                sta (PTR_ScreenPos),y
dpNextCh        iny
                cpy #4  ; 4 cols
                bne dploop0
                inc DP_Y
                dec DP_Rows     ; go to end of routine if no more rows
                beq dpend
                lda PTR_Piece   ; we add 4 to PTR_Piece to point to next row from the base adress to use y at 0
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0          ; add carry 0 to hi byte
                sta PTR_Piece+1
                jmp dpLoop1
dpend           rts
***
*** Draw Next Piece
***
DrawNextPiece   lda #0 ; default rotation
                ldx NextPieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx DP_Rows
                ldy #10 ; first line is 9
                sty DP_Y
dnpLoop1        ldy DP_Y
                ldx #$10
                jsr SetScreenPos2
                ldy #0
dnploop0        lda (PTR_Piece),y
                cmp #'.'
                bne dnpSetBrick
                lda #" " ; TODO constant
                jmp dnpDraw
dnpSetBrick     lda #$7f       ; TODO constant
dnpDraw         sta (PTR_ScreenPos),y
dnpNextCh       iny
                cpy #4  ; 4 cols
                bne dnploop0
                inc DP_Y
                dec DP_Rows     ; go to end of routine if no more rows
                beq dnpend
                lda PTR_Piece   ; we add 4 to PTR_Piece to point to next row from the base adress to use y at 0
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0          ; add carry 0 to hi byte
                sta PTR_Piece+1
                jmp dnpLoop1
dnpend          rts
***
***
***
DisplayScore    ldy #3
                ldx #29
                jsr SetScreenPos2
                ldx #0
                ldy #0
dsLoop0         lda Score,x
                pha
                lsr
                lsr
                lsr
                lsr
                and #$0f
                clc
                adc #$b0
                sta (PTR_ScreenPos),y
                iny
                pla
                and #$0f
                adc #$b0
                sta (PTR_ScreenPos),y
                iny
                inx
                cpx #5
                bne dsLoop0
                rts
***
***
***
DisplayHiScore  ldy #2
                ldx #29
                jsr SetScreenPos2
                ldx #0
                ldy #0
dhsLoop0        lda HighScore,x
                pha
                lsr
                lsr
                lsr
                lsr
                and #$0f
                clc
                adc #$b0
                sta (PTR_ScreenPos),y
                iny
                pla
                and #$0f
                adc #$b0
                sta (PTR_ScreenPos),y
                iny
                inx
                cpx #5
                bne dhsLoop0
                rts
***
***
***
IncScore        lda LinesCount
                asl ; multiply by 2
                tay
                iny ; lo byte is in +1
                ldx #4
                clc
                sed
                lda Score,x
                adc (PTR_Points),y
                sta Score,x
                dex
                dey
                lda Score,x
                adc (PTR_Points),y
                sta Score,x
                dex
                lda Score,x
                adc #0
                sta Score,x
                dex
                lda Score,x
                adc #0
                sta Score,x
                dex
                lda Score,x
                adc #0
                sta Score,x
                cld ; binary mode
                rts
***
***
***

DP_Y            dfb 0
DP_Rows         dfb 0
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
                cpy #FIELD_COLS
                bne DF_Loop0
                inx
                cpx #FIELD_ROWS
                beq DF_End
                clc                              ; clear carry flag
                lda PTR_Field         ; add 3 to lo byte of struct pointer to point to text to print
                adc #FIELD_COLS
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                jmp DF_Loop1
DF_End          rts
*
DF_FieldPosY    dfb 0
***
*** Display Line
***
DisplayLine     ldy #$00
                lda (PTR_DisplayLine),y     ; lo byte of the screen adress
                sta PTR_ScreenPos
                iny
                lda (PTR_DisplayLine),y     ; hi byte of the screen adress
                sta PTR_ScreenPos+1
                iny
                lda (PTR_DisplayLine),y     ; string length
                sta DLStrLen
                clc                         ; clear carry flag
                lda PTR_DisplayLine         ; add 3 to lo byte of struct pointer to point to text
                adc #$3
                sta PTR_DisplayLine         ; save new lo byte
                lda PTR_DisplayLine+1
                adc #$0                     ; will add 1 if the previous add set the carry flag
                sta PTR_DisplayLine+1       ; save hi byte
                ldy #$00
DisplayLineLoop lda (PTR_DisplayLine),y     ; get char to display
                sta (PTR_ScreenPos),y       ; copy to screen
                iny
                cpy DLStrLen
                bne DisplayLineLoop
                rts
DLStrLen        dfb 0 ; use the stack instead?
***
***  DoesPieceFit
***
***  Returns:
***    Carry flag on/off: Piece fits/doesn't fit
***
DoesPieceFit    ldx TryPieceX
                ldy TryPieceY
                jsr SetFieldPos2
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
                *lda #0
                *sta FlagPieceFits
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
                * increment FieldPos by FIELD_COLS
                lda PTR_Field
                clc
                adc #FIELD_COLS
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
                jsr SetFieldPos2
                lda PieceRot ; set ptr piece expects rotation in register a
                ldx PieceId
                jsr SetPtrPiece ;
                ldx #4
lpLoop1         ldy #0
lpLoop0         lda (PTR_Piece),y
                cmp #'.'
                beq lpNextCh
                * pixel is on, lock it on field
                lda #$7f       ; TODO constant
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
                * increment FieldPos by FIELD_COLS
                lda PTR_Field
                clc
                adc #FIELD_COLS
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
                ldy #2                           ; mark the line in the field for display
                lda #ChLines                     ; by using the line char
cflLoop1        sta (PTR_Field),y
                iny
                cpy #12                          ; loop if we haven't reach the right side
                bcc cflLoop1
cflNextRow      dex
                beq cflEnd
                lda PTR_Field
                clc
                adc #FIELD_COLS
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
                sbc #FIELD_COLS                 ; substract length of row from lo byte
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
                sbc #FIELD_COLS
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
*TODO clear top line!

***
*** CopyPieces: Copy "Piece*"" variables into "TryPiece*" variables
***
*----------------------------------------------------------------------------------------------------------------------
CopyPieces      pha
                lda PieceX
                sta TryPieceX
                lda PieceY
                sta TryPieceY
                lda PieceRot
                sta TryPieceRot
                pla
                rts
***
***
***
                put Spetris.Random
                put Spetris.Sleep
                put Spetris.Splash
***
***
***
FIELD_COLS      equ 14
FIELD_ROWS      equ 17
*Field           ds  160,$a0
* total field size is 14*17=238 so we can use an 8bit index
Field           dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
FieldBottom     dfb $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                dfb $a0,$a0,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$a0,$a0
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
                asc "S P E T R // S !"
HighScoreL      dfb $90,$06,22
                asc "High Score:           "
ScoreL          dfb $10,$07,22
                asc "Score:                "
LevelL          dfb $90,$07,22
                asc "Level:                "
TotalPiecesL    dfb $38,$04,22
                asc "Total Pieces:         "
NextPieceL      dfb $38,$05,11
                asc "Next Piece:"
PausedL         dfb $de,$06,11
                asc "P A U S E D"
PausedBlankL    dfb $de,$06,11
                asc "           "

*
PieceLen        equ 16
PieceStructLen  equ 4*PieceLen              ; 4 different rotations
Pieces          asc '..X...X...X...X.'   ; rotation 0 piece 0
                asc '........XXXX....'   ; rotation 1
                asc '.X...X...X...X..'   ; rotation 2
                asc '....XXXX........'   ; rotation 3
                asc '..X..XX...X.....'   ; rotation 0 piece 1
                asc '......X..XXX....'   ; rotation 1
                asc '.....X...XX..X..'   ; rotation 2
                asc '....XXX..X......'   ; rotation 3
                asc '.....XX..XX.....'   ; rotation 0 piece 2
                asc '.....XX..XX.....'   ; rotation 1
                asc '.....XX..XX.....'   ; rotation 2
                asc '.....XX..XX.....'   ; rotation 3
                asc '..X..XX..X......'   ; rotation 0 piece 3
                asc '.....XX...XX....'   ; rotation 1
                asc '......X..XX..X..'   ; rotation 2
                asc '....XX...XX.....'   ; rotation 3
                asc '.X...XX...X.....'   ; rotation 0 piece 4
                asc '......XX.XX.....'   ; rotation 1
                asc '.....X...XX...X.'   ; rotation 2
                asc '.....XX.XX......'   ; rotation 3
                asc '.X...X...XX.....'   ; rotation 0 piece 5
                asc '.....XXX.X......'   ; rotation 1
                asc '.....XX...X...X.'   ; rotation 2
                asc '......X.XXX.....'   ; rotation 3
                asc '..X...X..XX.....'   ; rotation 0 piece 6
                asc '.....X...XXX....'   ; rotation 1
                asc '.....XX..X...X..'   ; rotation 2
                asc '....XXX...X.....'   ; rotation 3
PieceId         dfb 0 ; these all get initialized in NewGame
NextPieceId     dfb 0
PieceX          dfb 0
PieceY          dfb 0
PieceRot        dfb 0
TryPieceX       dfb 0
TryPieceY       dfb 0
TryPieceRot     dfb 0
SpeedCountLo    dfb 0
SpeedCountHi    dfb 0
SpeedLo         dfb 0
SpeedHi         dfb 0
LinesCount      dfb 0
FlagForceDown   dfb 0
FlagRefreshScr  dfb 0
FlagFalling     dfb 0
FlagQuitGame    dfb 0
HighScore       dfb $00,$00,$00,$00,$00 ; bcd encoded
Score           dfb $00,$00,$00,$00,$00 ; bcd encoded
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
PTR_DisplayLine equ $fc
***
*** Game constants
***
SleepTime       equ $ff
ChTransparent   equ '.'
ChLines         equ "="
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
