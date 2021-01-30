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
