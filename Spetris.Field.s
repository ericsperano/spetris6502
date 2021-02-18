;***
;***
;***
SetFieldPos:    phy
                stx SSP_X
                InitPtr Field, PTR_Field
                cpy #0
                beq @end
@loop:          lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                dey
                bne @loop
@end:           lda PTR_Field
                clc
                adc SSP_X
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                ply
                rts
;***
;***
;***
InitField:      ldx #0
                lda #16                         ; TODO FieldRows - 1
                pha                             ; save rows counter on stack
@loop0:         lda #ASCII_Space                ; col 0 is always space (Not CharBG)
                sta Field,x
                inx
                lda CharLB                     ; col 1 is left bar
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda CharBG
@loop1:         sta Field,x                     ; BG for col 2 to 11
                inx
                dey
                bne @loop1
                lda CharRB                      ; col 12 is right bar
                sta Field,x
                inx
                lda #ASCII_Space                ; col 13 is space
                sta Field,x
                inx
                pla                             ; check current rows counter from stack
                sec
                sbc #1                          ; decrement
                pha                             ; put back on stack
                bne @loop0                      ; loop if more rows
                lda #ASCII_Space                ; last line, col 0 is space
                sta Field,x
                inx
                lda CharLC                      ; left corner
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda CharBB                      ; bottom bar for cols 2 to 11
@loop2:         sta Field,x
                inx
                dey
                bne @loop2
                lda CharRC                      ; right corner
                sta Field,x
                inx
                lda #ASCII_Space                ; always space (not CharBG)
                sta Field,x
                pla
                rts
;***
;***
;***
ConvertField:   ldx #0
                lda #16                         ; TODO FieldRows - 1
                pha                             ; save rows counter on stack
@loop0:         inx
                lda CharLB                      ; col 1 is left bar
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
@loop1:         lda Field,x
                cmp OldCharBG
                bne @setTile
                lda CharBG
                sta Field,x
                jmp @next
@setTile:       lda CharTile
                sta Field,x
@next:          inx
                dey
                bne @loop1
                lda CharRB                      ; col 12 is right bar
                sta Field,x
                inx
                inx
                pla                             ; check current rows counter from stack
                sec
                sbc #1                          ; decrement
                pha                             ; put back on stack
                bne @loop0                      ; loop if more rows
                inx                             ; skip space
                lda CharLC                      ; left corner
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda CharBB                      ; bottom bar for cols 2 to 11
@loop2:         sta Field,x
                inx
                dey
                bne @loop2
                lda CharRC                      ; right corner
                sta Field,x
                pla
                rts

;***
;***  DoesPieceFit
;***
;***  Returns:
;***    Carry flag on/off: Piece fits/doesn't fit
;***
DoesPieceFit:   ldx TryPieceX
                ldy TryPieceY
                jsr SetFieldPos
                lda TryPieceRot ; set ptr piece expects rotation in register a
                ldx PieceId
                jsr SetPtrPiece ;
                ldx #4
dpfLoop1:       ldy #0
dpfLoop0:       lda (PTR_Piece),y
                cmp #ChTransparent
                beq dpfNextCh
                ; pixel is on, need to check if it's empty in the field
                lda (PTR_Field),y
                cmp CharBG
                beq dpfNextCh
                clc                             ; clear carry and return, does not fit
                rts
dpfNextCh:      iny
                cpy #4
                bne dpfLoop0
                ; increment ptr_piece by 4
                lda PTR_Piece
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                ; increment FieldPos by FieldCols
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
;***
;***
;***
LockPiece:      ldx PieceX
                ldy PieceY
                jsr SetFieldPos
                lda PieceRot ; set ptr piece expects rotation in register a
                ldx PieceId
                jsr SetPtrPiece ;
                ldx #4
lpLoop1:        ldy #0
lpLoop0:        lda (PTR_Piece),y
                cmp #'.'
                beq lpNextCh
                ; pixel is on, lock it on field
                lda CharTile
                sta (PTR_Field),y
lpNextCh:       iny
                cpy #4
                bne lpLoop0
                ; increment ptr_piece by 4
                lda PTR_Piece
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                ; increment FieldPos by FieldCols
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
;***
;*** CheckForLines: goes through the field and check if there are any full lines
;*** this routine also updates the score by at least 25pts (we are called because a piece is locked)
;*** and by (1 << nblines) * 100
;***
CheckForLines:  lda #0
                sta LinesCount                  ; clear the lines count
                InitPtr Field, PTR_Field
                ldx #16
cflCheckRow:    ldy #2                          ; start at pos 2 in the row
cflLoop0:       lda (PTR_Field),y
                cmp CharBG                      ; is it the background?
                beq cflNextRow                  ; yeah so not a line, look next row
                iny                             ; no, keep looking previous char on row
                cpy #12                         ; loop if we haven't reach the right side
                bcc cflLoop0
                inc LinesCount
                ldy #2                          ; mark the line in the field for display
                lda CharLines                   ; by using the line char
cflLoop1:       sta (PTR_Field),y
                iny
                cpy #12                         ; loop if we haven't reach the right side
                bcc cflLoop1
cflNextRow:     dex
                beq cflEnd
                lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                jmp cflCheckRow
cflEnd:         rts
;***
;*** RemoveLines
;***
RemoveLines:    lda #<FieldBottom               ; start from the bottom
                sta PTR_Field                   ; save lo byte
                lda #>FieldBottom
                sta PTR_Field+1                 ; save hi byte
rlLoop0:        ldy #2                          ; start at pos 2 in the row
                lda (PTR_Field),y
                cmp CharLines                   ; is third char a line indicator?
                bne rlUp                        ; no, skip
                ;* move rows
                lda PTR_Field+1                 ; copy current pointer hi byte to tmp1
                sta PTR_FieldTmp1+1
                lda PTR_Field                   ; copy current pointer lo byte to tmp1
                sta PTR_FieldTmp1
rlLoop1:        sec                             ; set pointer tmp2 above current line
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
rlCopy:         ldy #2
rlCopyLoop:     lda (PTR_FieldTmp2),y           ; copy previous line
                sta (PTR_FieldTmp1),y
                iny
                cpy #12
                bne rlCopyLoop
                lda PTR_FieldTmp2+1
                sta PTR_FieldTmp1+1
                lda PTR_FieldTmp2
                sta PTR_FieldTmp1
                jmp rlLoop1
rlUp:           sec                             ; go up one row
                lda PTR_Field
                sbc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                sbc #0
                sta PTR_Field+1
                ;* check if we are at top
rlEnd:          lda PTR_Field+1
                cmp #>Field
                bne rlLoop0                     ; no, check previous line
                lda PTR_Field
                cmp #<Field
                bne rlLoop0                     ; no, check previous line
                rts
;***
;*** Draw Field
;***
DrawField:      InitPtr Field, PTR_Field
                InitPtr FieldPositions, PTR_FieldPos
                ldy #0
                ldx #0 ; row counter
                sty dfTmpPosY
                ;* initialize the screen pointer
dfLoop1:        ldy dfTmpPosY
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos+1
                iny
                sty dfTmpPosY                   ; save y for field pos
                ldy #0
dfLoop0:        lda (PTR_Field),y
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
dfEnd:          rts
dfTmpPosY:      .byte 0

;***
;***
;***
FieldCols       = 14
FieldRows       = 17
Field:          .res FieldCols * (FieldRows - 2) ; - 2 because of the following 2:
FieldBottom:    .res 2 * FieldCols ; last line ptr so FieldCols + another FieldCols for bottom bar
; total field size is 14*17=238 so we can use an 8bit index
; TODO use .addr instead of .byte
FieldPositions: .byte $80,$05
                .byte $00,$06
                .byte $80,$06
                .byte $00,$07
                .byte $80,$07
                .byte $28,$04
                .byte $a8,$04
                .byte $28,$05
                .byte $a8,$05
                .byte $28,$06
                .byte $a8,$06
                .byte $28,$07
                .byte $a8,$07
                .byte $50,$04
                .byte $d0,$04
                .byte $50,$05
                .byte $d0,$05
