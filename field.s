;
;
;
SetFieldPos     phy
                stx tmp1
                InitPtr Field;PTR_Field
                cpy #0
                beq :end
]loop           lda PTR_Field
                clc
                adc #FieldCols
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                dey
                bne ]loop
:end            lda PTR_Field
                clc
                adc tmp1
                sta PTR_Field
                lda PTR_Field+1
                adc #0
                sta PTR_Field+1
                ply
                rts
;
;
;
InitField       ldx #0
                lda #{FieldRows-1}
                pha                             ; save rows counter on stack
]loop0          lda #" "                        ; col 0 is always space (Not CharBG)
                sta Field,x
                inx
                lda TSLeftBar                   ; col 1 is left bar
                sta Field,x
                inx
                ldy #{FieldCols-4}
                lda TSBackground
]loop1          sta Field,x                     ; BG for col 2 to 11
                inx
                dey
                bne ]loop1
                lda TSRightBar                  ; col 12 is right bar
                sta Field,x
                inx
                lda #" "                        ; col 13 is space (Not CharBG)
                sta Field,x
                inx
                pla                             ; check current rows counter from stack
                sec
                sbc #1                          ; decrement
                pha                             ; put back on stack
                bne ]loop0                      ; loop if more rows
                lda #" "                        ; last line, col 0 is space
                sta Field,x
                inx
                lda TSLeftCorner                ; left corner
                sta Field,x
                inx
                ldy #{FieldCols-4}
                lda TSBottomBar                 ; bottom bar for cols 2 to 11
]loop2          sta Field,x
                inx
                dey
                bne ]loop2
                lda TSRightCorner               ; right corner
                sta Field,x
                inx
                lda #" "                        ; always space (not CharBG)
                sta Field,x
                pla
                rts
;
;
;
ConvertField    ldx #0
                lda #16                         ; TODO FieldRows - 1
                pha                             ; save rows counter on stack
]loop0          inx
                lda TSLeftBar                   ; col 1 is left bar
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
]loop1          lda Field,x
                cmp PreviousBG
                bne :setbox
                lda TSBackground
                sta Field,x
                bra :next
:setbox         lda TSBox
                sta Field,x
:next           inx
                dey
                bne ]loop1
                lda TSRightBar                  ; col 12 is right bar
                sta Field,x
                inx
                inx
                pla                             ; check current rows counter from stack
                sec
                sbc #1                          ; decrement
                pha                             ; put back on stack
                bne ]loop0                      ; loop if more rows
                inx                             ; skip space
                lda TSLeftCorner                ; left corner
                sta Field,x
                inx
                ldy #10                         ; TODO FieldCols - 4
                lda TSBottomBar                 ; bottom bar for cols 2 to 11
]loop2          sta Field,x
                inx
                dey
                bne ]loop2
                lda TSRightCorner               ; right corner
                sta Field,x
                pla
                rts
;
;  DoesPieceFit
;
;  Returns:
;    Carry flag on/off: Piece fits/doesn't fit
;
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
                ; pixel is on, need to check if it's empty in the field
                lda (PTR_Field),y
                cmp TSBackground
                beq dpfNextCh
                clc                             ; clear carry and return, does not fit
                rts
dpfNextCh       iny
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
;
;
;
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
                ; pixel is on, lock it on field
                lda TSBox
                sta (PTR_Field),y
lpNextCh        iny
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
;
; CheckForLines: goes through the field and check if there are any full lines
; this routine also updates the score by at least 25pts (we are called because a piece is locked)
; and by (1 << nblines) * 100
;
CheckForLines   lda #0
                sta LinesCount                  ; clear the lines count
                InitPtr Field;PTR_Field
                ldx #16
cflCheckRow     ldy #2                          ; start at pos 2 in the row
cflLoop0        lda (PTR_Field),y
                cmp TSBackground                ; is it the background?
                beq cflNextRow                  ; yeah so not a line, look next row
                iny                             ; no, keep looking previous char on row
                cpy #12                         ; loop if we haven't reach the right side
                bcc cflLoop0
                inc LinesCount
                ldy #2                          ; mark the line in the field for display
                lda TSLines                     ; by using the line char
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
                bra cflCheckRow
cflEnd          rts
;
; RemoveLines
;
RemoveLines     lda #<FieldBottom               ; start from the bottom
                sta PTR_Field                   ; save lo byte
                lda #>FieldBottom
                sta PTR_Field+1                 ; save hi byte
rlLoop0         ldy #2                          ; start at pos 2 in the row
                lda (PTR_Field),y
                cmp TSLines                     ; is third char a line indicator?
                bne rlUp                        ; no, skip
                ; move rows
                lda PTR_Field+1                 ; copy current pointer hi byte to tmp1
                sta PtrTmp1+1
                lda PTR_Field                   ; copy current pointer lo byte to tmp1
                sta PtrTmp1
                ;CopyPtr PTR_Field;PtrTmp1
                ;lda PtrTmp1                     ; even though CopyPtr has set A with PtrTmp1, load it again in case macro changes TODO maybe remove?
rlLoop1         sec                             ; set pointer tmp2 above current line
                sbc #FieldCols                  ; substract length of row from lo byte
                sta PtrTmp2
                lda PtrTmp1+1
                sbc #0                          ; substract carry from hi byte
                sta PtrTmp2+1
                cmp #>Field                     ; check if previous line is lower memory adr than beginning of field
                bcc rlEnd                       ; hi byte is lower yes, end
                bne rlCopy                      ; hi byte is not equal
                lda PtrTmp2                     ; check lo byte
                cmp #<Field
                beq rlEnd                       ; yes, end
rlCopy          ldy #2
rlCopyLoop      lda (PtrTmp2),y                 ; copy previous line
                sta (PtrTmp1),y
                iny
                cpy #{FieldCols-2}
                bne rlCopyLoop
                lda PtrTmp2+1
                sta PtrTmp1+1
                lda PtrTmp2
                sta PtrTmp1
                bra rlLoop1
rlUp            sec                             ; go up one row
                lda PTR_Field
                sbc #FieldCols                  ; by substracting the number of cols in a row
                sta PTR_Field
                lda PTR_Field+1
                sbc #0
                sta PTR_Field+1
                ; check if we are at top
rlEnd           lda PTR_Field+1
                cmp #>Field
                bne rlLoop0                     ; no, check previous line
                lda PTR_Field
                cmp #<Field
                bne rlLoop0                     ; no, check previous line
                InitPtr Field;PTR_Field
initFirstLine   ldy #2
                lda TSBackground
]loop           sta (PtrTmp1),y
                iny
                cpy #{FieldCols-2}
                bne ]loop
                rts
;
; Draw Field
;
DrawField       InitPtr Field;PTR_Field
                InitPtr FieldPositions;PTR_FieldPos
                ldy #0
                ldx #0 ; row counter
                sty dfTmpPosY
                ; initialize the screen pointer
]loop1          ldy dfTmpPosY
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos
                iny
                lda (PTR_FieldPos),y
                sta PTR_ScreenPos+1
                iny
                sty dfTmpPosY                   ; save y for field pos
                ldy #0
]loop0          lda (PTR_Field),y
                sta (PTR_ScreenPos),y
                iny
                cpy #FieldCols
                bne ]loop0
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
                bra ]loop1
dfEnd           rts
dfTmpPosY       dfb 0
;
;
;
FieldCols       equ 14
FieldRows       equ 17
Field           ds  210, 0    ; FieldCols * (FieldRows - 2)  2 because of the following 2
FieldBottom     ds  28, 0     ; last line ptr so FieldCols + another FieldCols for bottom bar
; total field size is 14*17=238 so we can use an 8bit index
; TODO use define word?
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
