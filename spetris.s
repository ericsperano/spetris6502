* SPETRIS FOR APPLE II COMPUTERS
                org $2000
KYBD            equ $c000
STROBE          equ $c010
HOME            equ $fc58
TEXTON          equ $c051
80COLOFF        equ $c00c
80COLON         equ $c00d
PTR1            equ $06
PTR2            equ $08
PTR3            equ $1d
PTR_Piece       equ $ce
PTR_Field       equ $eb
PTR_FieldPos    equ $ed
PTR_ScreenPos   equ $fa
PTR_DisplayLine equ $fc
*
FIELD_COLS      equ 10
FIELD_ROWS      equ 16
*
JSRDisplayLine  MAC
                lda #<]1                    ; lo byte of struct to display
                sta PTR_DisplayLine
                lda #>]1                    ; hi byte of struct to display
                sta PTR_DisplayLine+1
                jsr DisplayLine
                <<<
                *sta 80COLOFF
                *sta TEXTON
                *sta     80COLOFF
                jsr HOME
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
LoopAnyKey      lda KYBD
                cmp #$80
                bcc LoopAnyKey
                *
                sta STROBE
                jsr HOME
                jsr DrawScreen
                jsr DrawField
                jsr DrawPiece
LoopAnyKey2     lda KYBD
                cmp #$80
                bcc LoopAnyKey2
                *
                sta STROBE
                jsr HOME
                rts
***
*** Set PTR_Piece according to PieceId and PieceRot
**  Trashes A,X
***
SetPtrPiece     lda #<Pieces                    ; lo byte of struct to display
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
SPP_testRot     ldx PieceRot
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
                asl
                tay
                stx SSP_X
                lda #<FieldPositions
                sta PTR_FieldPos
                lda #>FieldPositions
                sta PTR_FieldPos+1
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
*
SSP_X           dfb 0
***
*** Draw Piece
***
DrawPiece       jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx DP_Rows
                ldy PieceY      ; use a copy of PieceY (DP_Y) to not increment the real variable
                sty DP_Y
dpLoop1         ldy DP_Y
                ldx PieceX
                jsr SetScreenPos
                ldy #0
dploop0         lda (PTR_Piece),y
                cmp #"."
                beq dpNextCh
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
DrawScreen      lda #<FieldPositions ; init the zero page pointers
                sta PTR_FieldPos
                lda #>FieldPositions
                sta PTR_FieldPos+1
                ldy #0
                ldx #0 ; row counter
                sty DF_FieldPosY
DS_Loop0        ldy DF_FieldPosY
                lda (PTR_FieldPos),y
                sec
                sbc #1
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos+1
                iny
                sty DF_FieldPosY
                ldy #0
                lda #$3a   ; bar character
                sta (PTR_ScreenPos),y
                ldy #FIELD_COLS+1
                sta (PTR_ScreenPos),y
                inx
                cpx #FIELD_ROWS
                bne DS_Loop0
                JSRDisplayLine GridBottom
                JSRDisplayLine Title
                JSRDisplayLine HighScoreL
                JSRDisplayLine ScoreL
                JSRDisplayLine TotalPiecesL
                JSRDisplayLine NextPieceL
                rts
***
*** Draw Field
***
DrawField       lda #<Field ; init the zero page pointers
                sta PTR_Field
                lda #>Field
                sta PTR_Field+1
                lda #<FieldPositions
                sta PTR_FieldPos
                lda #>FieldPositions
                sta PTR_FieldPos+1
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
*
Field           ds  160,$a0
FieldPositions  dfb $82,$05
                dfb $02,$06
                dfb $82,$06
                dfb $02,$07
                dfb $82,$07
                dfb $2a,$04
                dfb $aa,$04
                dfb $2a,$05
                dfb $aa,$05
                dfb $2a,$06
                dfb $aa,$06
                dfb $2a,$07
                dfb $aa,$07
                dfb $52,$04
                dfb $d2,$04
                dfb $52,$05
*
Splash00        dfb $8b,$04,16
                asc "S P E T R // S !"
Splash01        dfb $87,$05,24
                asc "For "
                dfb $40
                asc " Apple // Computers"
Splash02        dfb $30,$04,22
                asc "Keyboard Game Controls"
Splash03        dfb $2d,$05,29
                asc "Left Arrow:   Move Piece Left"
Splash04        dfb $ad,$05,30
                asc "Right Arrow:  Move Piece Right"
Splash05        dfb $2d,$06,26
                asc "Up Arrow:     Rotate Piece"
Splash06        dfb $ad,$06,29
                asc "Down Arrow:   Move Piece Down"
Splash07        dfb $2d,$07,24
                asc "Space Bar:    Drop Piece"
Splash08        dfb $ad,$07,24
                asc "P:            Pause Game"
Splash09        dfb $55,$04,23
                asc "Esc:          Quit Game"
Splash10        dfb $d8,$06,22
                asc "Press Any Key To Start"
*
GridBottom      dfb $d1,$05,12
                asc '::::::::::::'
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
Pieces          asc "..X...X...X...X."   ; rotation 0 piece 0
                asc "........XXXX...."   ; rotation 1
                asc ".X...X...X...X.."   ; rotation 2
                asc "....XXXX........"   ; rotation 3
                asc "..X..XX...X....."   ; rotation 0 piece 1
                asc "......X..XXX...."   ; rotation 1
                asc ".....X...XX..X.."   ; rotation 2
                asc "....XXX..X......"   ; rotation 3
                asc ".....XX..XX....."   ; rotation 0 piece 2
                asc ".....XX..XX....."   ; rotation 1
                asc ".....XX..XX....."   ; rotation 2
                asc ".....XX..XX....."   ; rotation 3
                asc "..X..XX..X......"   ; rotation 0 piece 3
                asc ".....XX...XX...."   ; rotation 1
                asc "......X..XX..X.."   ; rotation 2
                asc "....XX...XX....."   ; rotation 3
                asc ".X...XX...X....."   ; rotation 0 piece 4
                asc "......XX.XX....."   ; rotation 1
                asc ".....X...XX...X."   ; rotation 2
                asc ".....XX.XX......"   ; rotation 3
                asc ".X...X...XX....."   ; rotation 0 piece 5
                asc ".....XXX.X......"   ; rotation 1
                asc ".....XX...X...X."   ; rotation 2
                asc "......X.XXX....."   ; rotation 3
                asc "..X...X..XX....."   ; rotation 0 piece 6
                asc ".....X...XXX...."   ; rotation 1
                asc ".....XX..X...X.."   ; rotation 2
                asc "....XXX...X....."   ; rotation 3
PieceId         dfb 6
PieceX          dfb 3
PieceY          dfb 0
PieceRot        dfb 3
