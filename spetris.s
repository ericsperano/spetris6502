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
PTR4            equ $ce
PTR_Field       equ $eb
PTR_FieldPos    equ $ed
PTR_ScreenPos   equ $fa
PTR_DisplayLine equ $fc
*
FIELD_COLS      equ 10
FIELD_ROWS      equ 10
*
JSRDisplayLine  MAC
                lda #<]1                    ; lo byte of struct to display
                sta PTR_DisplayLine
                lda #>]1                    ; hi byte of struct to display
                sta PTR_DisplayLine+1
                jsr DisplayLine
                <<<
*
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
                sta STROBE
                jsr HOME
                jsr DrawScreen
                jsr DrawField
LoopAnyKey2     lda KYBD
                cmp #$80
                bcc LoopAnyKey2
                sta STROBE
                jsr HOME
                rts
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
*
***
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
Field           asc "A         "
                asc " B        "
                asc "  C       "
                asc "          "
                asc "          "
                asc "          "
                asc "   EE     "
                asc "  DD   FFF"
                asc " CC    FFF"
                asc "BABABA FFF"
FieldPositions  dfb $01,$04
                dfb $81,$04
                dfb $01,$05
                dfb $81,$05
                dfb $01,$06
                dfb $81,$06
                dfb $01,$07
                dfb $81,$07
                dfb $29,$04
                dfb $a9,$04
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
GridBottom      dfb $28,$05,12
                asc '::::::::::::'
