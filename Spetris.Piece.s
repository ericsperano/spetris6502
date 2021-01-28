***
*** Set PTR_Piece
***  A=rotation
***  X=pieceID
***  Trashes A,X
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
*** Draw Piece
***
DrawPiece       lda PieceRot
                ldx PieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx drawPieceRows
                ldy PieceY      ; use a copy of PieceY (drawPieceY) to not increment the real variable
                sty drawPieceY
dpLoop1         ldy drawPieceY
                ldx PieceX
                jsr SetScreenPos
                ldy #0
dploop0         lda (PTR_Piece),y
                cmp #ChTransparent
                beq dpNextCh
                lda #ChTile
                sta (PTR_ScreenPos),y
dpNextCh        iny
                cpy #4  ; 4 cols
                bne dploop0
                inc drawPieceY
                dec drawPieceRows     ; go to end of routine if no more rows
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
drawPieceY      dfb 0
drawPieceRows   dfb 0
***
*** Draw Next Piece
***
DrawNextPiece   lda #0 ; default rotation
                ldx NextPieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx drawPieceRows
                ldy #10 ; first line is 9
                sty drawPieceY
dnpLoop1        ldy drawPieceY
                ldx #$10
                jsr SetScreenPos
                ldy #0
dnploop0        lda (PTR_Piece),y
                cmp #'.'
                bne dnpSetBrick
                lda #" " ; TODO constant
                jmp dnpDraw
dnpSetBrick     lda #ChTile
dnpDraw         sta (PTR_ScreenPos),y
dnpNextCh       iny
                cpy #4  ; 4 cols
                bne dnploop0
                inc drawPieceY
                dec drawPieceRows     ; go to end of routine if no more rows
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
IncTotalPieces  sed                             ; bcd mode
                clc
                ldx #2                          ; 3 bytes - 1
                lda TotalPieces,x
                adc #1
                sta TotalPieces,x
                dex
                lda TotalPieces,x
                adc #0
                sta TotalPieces,x
                dex
                lda TotalPieces,x
                adc #0
                sta TotalPieces,x
                dex
                cld                             ; binary mode
                rts
***
***
***
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
*** InitTryPieces: Copy "Piece*"" variables into "TryPiece*" variables
***
InitTryPieces   pha                             ; save a
                lda PieceX                      ; copy x
                sta TryPieceX
                lda PieceY                      ; copy y
                sta TryPieceY
                lda PieceRot                    ; copy rotation
                sta TryPieceRot
                pla                             ; restore a
                rts
***
***
***
TotalPiecesL    dfb $38,$04,13
                asc "Total Pieces:"
NextPieceL      dfb $38,$05,11
                asc "Next Piece:"
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
TotalPiecesBCD  dfb $47,$04,$03
TotalPieces     dfb $00,$00,$00
