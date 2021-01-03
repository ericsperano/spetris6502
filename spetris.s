* SPETRIS FOR APPLE II COMPUTERS
                org $2000
KYBD            equ $c000
STROBE          equ $c010
HOME            equ $fc58
ALTCHARSETOFF   equ $c00e
ALTCHARSETON    equ $c00f
PTR1            equ $06
PTR2            equ $08
PTR3            equ $1d
PTR_Piece       equ $ce
PTR_Field       equ $eb
PTR_FieldPos    equ $ed
PTR_ScreenPos   equ $fa
PTR_DisplayLine equ $fc
*
JSRDisplayLine  MAC
                lda #<]1                    ; lo byte of struct to display
                sta PTR_DisplayLine
                lda #>]1                    ; hi byte of struct to display
                sta PTR_DisplayLine+1
                jsr DisplayLine
                <<<
InitPtrField    MAC
                lda #<Field
                sta PTR_Field
                lda #>Field
                sta PTR_Field+1
                <<<
InitPtrFieldPos MAC
                lda #<FieldPositions
                sta PTR_FieldPos
                lda #>FieldPositions
                sta PTR_FieldPos+1
                <<<
InitPtrPiece    MAC
                lda #<Pieces
                sta PTR_Piece
                lda #>Pieces
                sta PTR_Piece+1
                <<<
                * BEGIN PROGRAM
                jsr SplashScreen
                jsr NewGame
                jsr HOME
                jsr DrawScreen
loopDraw0       jsr NewRound
                jsr DrawField
                jsr DrawPiece
LoopAnyKey2     lda SleepCounterLo
                clc
                adc #1
                sta SleepCounterLo
                lda SleepCounterHi
                adc #0
                sta SleepCounterHi
                *cmp #0
                bne pollKeyboard
                lda SleepCounterLo
                bne pollKeyboard
                lda #1
                sta FlagForceDown
                jmp chkForceDown
pollKeyboard    lda KYBD
                cmp #$80
                bcc LoopAnyKey2
                *
                sta STROBE
                jsr CopyPieces
                cmp #$8b ; arrow up
                bne testLeftKey
                ldx PieceRot
                bne decRot
                ldx #3
                jmp storeRot
decRot          dex
storeRot        stx TryPieceRot
                jsr DoesPieceFit
                ldx PieceFitsFlag
                beq chkForceDown
                ldx TryPieceRot
                stx PieceRot
                jmp chkForceDown
testLeftKey     cmp #$88 ; arrow left
                bne testRightKey
                dec TryPieceX
                jsr DoesPieceFit
                ldx PieceFitsFlag
                beq chkForceDown
                dec PieceX
                jmp chkForceDown
testRightKey    cmp #$95 ; arrow right
                bne testDownKey
                inc TryPieceX
                jsr DoesPieceFit
                ldx PieceFitsFlag
                beq chkForceDown
                inc PieceX
                jmp chkForceDown
testDownKey     cmp #$8a ; arrow bottom       ; TODO reset the forcedown
                bne testEscKey
                inc TryPieceY
                jsr DoesPieceFit
                ldx PieceFitsFlag
                beq chkForceDown
                inc PieceY
                jmp chkForceDown
testEscKey      cmp #$9b ; esc
                beq endgame
                jmp loopDraw0 ;loop back TODO relative instead of jmp?
chkForceDown    lda chkForceDown
                beq endLoopRound
                inc TryPieceY
                jsr DoesPieceFit
                ldx PieceFitsFlag
                beq endLoopRound
                inc PieceY
endLoopRound    jmp loopDraw0
endgame         jsr HOME
                rts
***
***
***
NewGame         lda #0
                sta PieceId
                sta PieceY
                sta PieceRot
                lda #5
                sta PieceX
                rts
NewRound        lda #0
                sta SleepCounterLo
                sta FlagForceDown
                lda #$b0
                sta SleepCounterHi
                rts
***
*** Set PTR_Piece according to PieceId and PieceRot
**  A=rotation
**  Trashes A,X
***
SetPtrPiece     pha                             ; save rotation on stack
                lda #<Pieces                    ; lo byte of struct to display
                sta PTR_Piece
                lda #>Pieces                    ; hi byte of struct to display
                sta PTR_Piece+1
                ldx PieceId
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
                InitPtrFieldPos
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
                InitPtrFieldPos
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
                InitPtrField
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
                cmp #'.'
                beq dpNextCh
                lda #$23
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
*
DP_Y            dfb 0
DP_Rows         dfb 0
***
*** Draw Screen
***
DrawScreen      InitPtrFieldPos
                sta ALTCHARSETON
                *JSRDisplayLine GridBottom
                JSRDisplayLine Title
                JSRDisplayLine HighScoreL
                JSRDisplayLine ScoreL
                JSRDisplayLine TotalPiecesL
                JSRDisplayLine NextPieceL
                rts
***
*** Draw Field
***
DrawField       InitPtrField
                InitPtrFieldPos
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
***
***
PieceFitsFlag   dfb 0
DoesPieceFit    lda #1
                sta PieceFitsFlag               ; piece fit by default
                ldx TryPieceX
                ldy TryPieceY
                jsr SetFieldPos2
                lda TryPieceRot ; set ptr piece expects rotation in register a
                jsr SetPtrPiece
                ldx #4
dpfLoop1        ldy #0
dpfLoop0        lda (PTR_Piece),y
                cmp #'.'
                beq dpfNextCh
                * pixel is on, need to check if it's empty in the field
                lda (PTR_Field),y
                cmp #" "
                beq dpfNextCh
                lda #0
                sta PieceFitsFlag
                jmp dpfEnd
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
dpfEnd          rts
*DoesPieceFit    PSHU    A,B,X,Y,CC              ; save registers
*                LDX     #Piece2
*                _SRF    #FPieceFits             ; piece fit by default
*                LDB     PieceY,X
*                LDA     #FieldWidth             ; cols per line
*                MUL
*                ADDB    PieceX,X                ; add X
*                ADDD    #Field
*                PSHU    D
*                ADDD    #(3*FieldWidth)+4       ; where we stop to check
*                STD     dpfFieldEndAddr
*                LDA     PieceId,X
*                LDB     #PieceStructLen
*                MUL
*                ADDD    #Pieces
*                TFR     D,Y                     ; X now points to the beginning of the piece struct to check
*                LDA     #PieceLen
*                LDB     PieceRot,X
*                MUL
*                LEAX    D,Y                     ; x now should point to the good rotated shape to draw
*                PULU    Y                       ; Y == field pos where we start to check
*dpfLoopRow0     LDB     #4                      ; 4 "pixels' per row
*dpfLoopRow1     LDA     ,X+
*                CMPA    #ChDot
*                BNE     dpfCheck                ; not a dot, we must check
*                LEAY    1,Y                     ; won't check but still need to move to next pos on the field
*                JMP     dpfEndCheck
*dpfCheck        LDA     ,Y+                     ; the char to draw, from the stack
*                CMPA    #ChSpc
*                BEQ     dpfEndCheck
*                _CRF    #FPieceFits             ; piece does not fit
*                JMP     dpfEnd
*dpfEndCheck     DECB
*                BNE     dpfLoopRow1
*                CMPY    dpfFieldEndAddr         ; are we done checking?
*                BGE     dpfEnd
*                LEAY    (FieldWidth-4),Y        ; move at the beginning of next line on video ram (32-width=28)
*                JMP     dpfLoopRow0
*dpfEnd          PULU    A,B,X,Y,CC              ; restore the registers
*                RTS
*dpfFieldEndAddr FDB     0
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
SplashScreen    jsr HOME
                sta ALTCHARSETON
                JSRDisplayLine Splash00
                JSRDisplayLine Splash01
                JSRDisplayLine Splash02
                JSRDisplayLine Splash03
                JSRDisplayLine Splash04
                JSRDisplayLine Splash05
                JSRDisplayLine Splash06
                JSRDisplayLine Splash07
                JSRDisplayLine Splash08
                JSRDisplayLine Splash09
                JSRDisplayLine Splash10
                * get key
splashLoop0     lda KYBD
                cmp #$80
                bcc splashLoop0
                *
                sta STROBE
                rts
***
***
***
FIELD_COLS      equ 14
FIELD_ROWS      equ 17
*Field           ds  160,$a0
Field           asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
                asc $a0,$5a,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0,$5f,$a0
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
Splash00        dfb $8b,$04,16
                asc "S P E T R // S !"
Splash01        dfb $87,$05,24
                asc "For "
                dfb $40
                asc " Apple // Computers"
Splash02        dfb $30,$04,22
                asc "Keyboard Game Controls"
Splash03        dfb $30,$05,19
                dfb $4b
                asc "      Rotate Piece"
Splash04        dfb $b0,$05,22
                dfb $48
                asc "      Move Piece Left"
Splash05        dfb $30,$06,23
                dfb $55
                asc "      Move Piece Right"
Splash06        dfb $b0,$06,22
                dfb $4a
                asc "      Move Piece Down"
Splash07        dfb $30,$07,17
                asc "Space  Drop Piece"
Splash08        dfb $b0,$07,17
                asc "P      Pause Game"
Splash09        dfb $58,$04,16
                asc "Esc    Quit Game"
Splash10        dfb $d8,$06,22
                asc "Press Any Key To Start"
*
*GridBottom      dfb $d1,$05,12
*                asc '::::::::::::'
Title           dfb $93,$05,16
                asc "S P E T R // S !"
HighScoreL      dfb $90,$06,22
                asc "High Score:           "
ScoreL          dfb $10,$07,22
                asc "Score:                "
TotalPiecesL    dfb $90,$07,22
                asc "Total Pieces:         "
NextPieceL      dfb $b8,$04,11
                asc "Next Piece:"
*
PiecesMono      asc 'ABCDEFG'
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
PieceX          dfb 0
PieceY          dfb 0
PieceRot        dfb 0
TryPieceX       dfb 0
TryPieceY       dfb 0
TryPieceRot     dfb 0
SleepCounterLo  dfb 0
SleepCounterHi  dfb 0
FlagForceDown   dfb 0
