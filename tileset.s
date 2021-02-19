;
; UseTileset: Use the tileset that is specified in TilesetID.
;
; Copy 8 bytes from Tilesets (offset by TilesetID * TilesetSize) into the 9 TS* variables
;
; Trashes: A, X, Y
;
UseTileset      lda TSBackground
                sta PreviousBG
                clc                             ; multiple TilesetID * TilesetSize
                lda #0
                ldy TilesetID
                beq :copyatox
]loop0          adc #TilesetSize
                dey
                bne ]loop0
:copyatox       tax                             ; copy result in X
                InitPtr TSBox;PtrTmp1           ; ptr to the first TS variable
                ldy #0                          ; init counter
]loop1          lda Tilesets,x                  ; copy tile
                sta (PtrTmp1),y
                inx                             ; incr counters
                iny
                cpy #TilesetSize                ; end of struct?
                bne ]loop1
                rts
;
; Tilesets for //e or ][+
; TODO box for new piecen
                DO ]APPLE2E
                ;    box, lines, lb, rb, lc, rc, bb, bg, nxbg
Tilesets        dfb $7f, $ff, $5a, $5f, " ", " ", $4c, " ", " "
                dfb $54, $5d, "|", "|", $5b, $5b, $53, $56, $57
                dfb $5e, $45, " ", " ", " ", " ", " ", ' ', " "
                dfb $40, $41, $5a, $5f, " ", " ", $4c, " ", " "
                dfb $ff, $7f, " ", " ", " ", " ", " ", ' ', " "
                dfb $5e, $44, "|", "|", $5b, $5b, $53, " ", " "
                dfb $4e, $43, $56, $56, $56, $56, $56, " ", " "
                dfb $56, $47, $43, $43, $5d, $5d, $5c, " ", " "
                dfb $5b, $49, $50, $4f, $1c, $2f, $52, " ", " "
                dfb $44, $5d, $55, $48, $55, $48, $52, $45, " "
                dfb '#', "=", "!", "!", "+", "+", "-", " ", " "
                dfb "O", "X", "]", "[", "T", "T", "T", " ", " "
                ELSE
                ;    box, lines, lb, rb, lc, rc, bb, bg
Tilesets        dfb '#', "=", "!", "!", "+", "+", "-", " ", " "
                dfb "#", '-', " ", " ", " ", " ", " ", ' ', " "
                dfb "O", "X", "]", "[", "T", "T", "T", " ", " "
                FIN
;
; "Live" tileset variables
;
; Important: Update the TilesetSize constant when adding/removing a TS variable!
; Important: The order should be the same as Tilesets above!
;
TSBox           dfb 0
TSLines         dfb 0
TSLeftBar       dfb 0
TSRightBar      dfb 0
TSLeftCorner    dfb 0
TSRightCorner   dfb 0
TSBottomBar     dfb 0
TSBackground    dfb 0
TSNextBG        dfb 0
;
TilesetID       dfb 0
PreviousBG      dfb 0
