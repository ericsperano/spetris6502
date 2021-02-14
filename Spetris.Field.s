***
***
***
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
***
***
InitField       ldx #0
                lda #16                         ; TODO FieldRows - 1
                pha                             ; save rows counter on stack
ifLoop0         lda #" "                        ; col 0 is space
                sta Field,x
                inx
                lda #LB                         ; col 1 is left bar
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda #BG
ifLoop1         sta Field,x                     ; BG for col 2 to 11
                inx
                dey
                bne ifLoop1
                lda #RB                         ; col 12 is right bar
                sta Field,x
                inx
                lda #" "                        ; col 13 is space
                sta Field,x
                inx
                pla                             ; check current rows counter from stack
                sec
                sbc #1                          ; decrement
                pha                             ; put back on stack
                bne ifLoop0                     ; loop if more rows
                lda #" "                        ; last line, col 0 is space
                sta Field,x
                inx
                lda #LC                         ; left corner
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda #BB                         ; bottom bar for cols 2 to 11
ifLoop2         sta Field,x
                inx
                dey
                bne ifLoop2
                lda #RC                         ; right corner
                sta Field,x
                inx
                lda #" "                        ; space
                sta Field,x
                pla
                rts
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
                cmp #BG
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
                cmp #BG                         ; is it a space? TODO constant
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
*** Draw Field
***
DrawField       InitPtr Field;PTR_Field
                InitPtr FieldPositions;PTR_FieldPos
                ldy #0
                ldx #0 ; row counter
                sty dfTmpPosY
                * initialize the screen pointer
dfLoop1         ldy dfTmpPosY
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos+1
                iny
                sty dfTmpPosY                   ; save y for field pos
                ldy #0
dfLoop0         lda (PTR_Field),y
                sta (PTR_ScreenPos),y
                iny
                cpy #FieldCols
                bne dfLoop0
                inx
                cpx #FieldRows
                beq dfEnd
                clc                              ; clear carry flag
                lda PTR_Field         ; add 3 to lo byte of struct pointer to point to text to print
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                jmp dfLoop1
dfEnd           rts
dfTmpPosY       dfb 0

***
***
***

***
***
***
FieldCols       equ 14
FieldRows       equ 17
Field           ds  210, 0    ; FieldCols * (FieldRows - 2)  2 because of the following 2
FieldBottom     ds  28, 0     ; last line ptr so FieldCols + another FieldCols for bottom bar
* total field size is 14*17=238 so we can use an 8bit index
                DO ]USE_EXT_CHAR
LB              equ $5a
RB              equ $5f
LC              equ " "
RC              equ " "
BB              equ $4c
BG              equ " "
                ELSE
LB              equ " "
RB              equ " "
LC              equ " "
RC              equ " "
BB              equ " "
BG              equ ' '
                FIN
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
