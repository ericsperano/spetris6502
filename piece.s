;
; Set PTR_Piece
;  A=rotation
;  X=pieceID
;  Trashes A,X
;
SetPtrPiece     pha                             ; save rotation on stack
                lda #<Pieces                    ; lo byte of struct to display
                sta PTR_Piece
                lda #>Pieces                    ; hi byte of struct to display
                sta PTR_Piece+1
                cpx #0
                beq :testRot
]loop0          clc
                lda PTR_Piece
                adc #PieceStructLen
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                dex
                bne ]loop0
:testRot        pla ; take rotation from stack
                tax
                beq :end
]loop1          clc
                lda PTR_Piece
                adc #PieceLen
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0
                sta PTR_Piece+1
                dex
                bne ]loop1
:end            rts
;
; Draw Piece
;
DrawPiece       lda PieceRot
                ldx PieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx drawPieceRows
                ldy PieceY      ; use a copy of PieceY (drawPieceY) to not increment the real variable
                sty drawPieceY
]loop1          ldy drawPieceY
                ldx PieceX
                jsr SetScreenPos
                ldy #0
]loop0          lda (PTR_Piece),y
                cmp #ChTransparent
                beq :nextCh
                lda TSBox
                sta (PTR_ScreenPos),y
:nextCh         iny
                cpy #4  ; 4 cols
                bne ]loop0
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
                bra ]loop1
dpend           rts
drawPieceY      dfb 0
drawPieceRows   dfb 0
;
; Draw Next Piece
;
DrawNextPiece   lda NextRotation
                ldx NextPieceId
                jsr SetPtrPiece
                ldx #4 ; 4 rows
                stx drawPieceRows
                ldy #NextPieceY
                sty drawPieceY
]loop1          ldy drawPieceY
                ldx #$10
                jsr SetScreenPos
                ldy #0
]loop0          lda (PTR_Piece),y
                cmp #'.'
                bne :setBrick
                lda TSNextBG
                bra :draw
:setBrick       lda TSBox
:draw           sta (PTR_ScreenPos),y
                iny
                cpy #4  ; 4 cols
                bne ]loop0
                inc drawPieceY
                dec drawPieceRows     ; go to end of routine if no more rows
                beq :end
                lda PTR_Piece   ; we add 4 to PTR_Piece to point to next row from the base adress to use y at 0
                clc
                adc #4
                sta PTR_Piece
                lda PTR_Piece+1
                adc #0          ; add carry 0 to hi byte
                sta PTR_Piece+1
                bra ]loop1
:end            rts
;
; IncTotalPieces: Increment the global Total Pieces counter
;
IncTotalPieces  sed                             ; bcd mode
                clc
                ldx #2                          ; 3 bytes - 1 TODO constant
                lda TotalPiecesBCD,x
                adc #1
                sta TotalPiecesBCD,x
                dex
                lda TotalPiecesBCD,x
                adc #0
                sta TotalPiecesBCD,x
                dex
                lda TotalPiecesBCD,x
                adc #0
                sta TotalPiecesBCD,x
                dex
                cld                             ; binary mode
                rts
;
; NewPiece: NextPiece becomde NewPiece and a new random NextPiece is generated
;
;
NewPiece        pha
                lda #0                          ; initialize piece variables
                sta PieceY
                sta FlagFalling
                lda #5                          ; centered in the field
                sta PieceX
                lda NextPieceId                 ; next piece id becomes current piece id
                sta PieceId
                lda NextRotation                ; next piece rotation becomes current rotation
                sta PieceRot
]loop           jsr RandomNumber                ; Get a random number from 0 to ff
                lda Rand
                and #%00000111                  ; keep the last 3 bits (0 to 7)
                cmp #7                          ; we just need 0 to 6 (7 pieces)
                beq ]loop
                sta NextPieceId                 ; save random piece id
                jsr RandomNumber                ; get a random rotation
                and #%00000011                  ; keep values 0-3
                sta NextRotation
                pla
                rts
;
; InitTryPieces: Copy "Piece*"" variables into "TryPiece*" variables
;
InitTryPieces   pha                             ; save a
                lda PieceX                      ; copy x
                sta TryPieceX
                lda PieceY                      ; copy y
                sta TryPieceY
                lda PieceRot                    ; copy rotation
                sta TryPieceRot
                pla                             ; restore a
                rts
;
;
;
ChTransparent   equ '.'
PieceLen        equ 16
PieceStructLen  equ 4*PieceLen                  ; 4 different rotations
Pieces          asc '..X...X...X...X.'          ; rotation 0 piece 0
                asc '........XXXX....'          ; rotation 1
                asc '.X...X...X...X..'          ; rotation 2
                asc '....XXXX........'          ; rotation 3
                asc '..X..XX...X.....'          ; rotation 0 piece 1
                asc '......X..XXX....'          ; rotation 1
                asc '.....X...XX..X..'          ; rotation 2
                asc '....XXX..X......'          ; rotation 3
                asc '.....XX..XX.....'          ; rotation 0 piece 2
                asc '.....XX..XX.....'          ; rotation 1
                asc '.....XX..XX.....'          ; rotation 2
                asc '.....XX..XX.....'          ; rotation 3
                asc '..X..XX..X......'          ; rotation 0 piece 3
                asc '.....XX...XX....'          ; rotation 1
                asc '......X..XX..X..'          ; rotation 2
                asc '....XX...XX.....'          ; rotation 3
                asc '.X...XX...X.....'          ; rotation 0 piece 4
                asc '......XX.XX.....'          ; rotation 1
                asc '.....X...XX...X.'          ; rotation 2
                asc '.....XX.XX......'          ; rotation 3
                asc '.X...X...XX.....'          ; rotation 0 piece 5
                asc '.....XXX.X......'          ; rotation 1
                asc '.....XX...X...X.'          ; rotation 2
                asc '......X.XXX.....'          ; rotation 3
                asc '..X...X..XX.....'          ; rotation 0 piece 6
                asc '.....X...XXX....'          ; rotation 1
                asc '.....XX..X...X..'          ; rotation 2
                asc '....XXX...X.....'          ; rotation 3
PieceId         dfb 0 ; these all get initialized in NewGame
NextPieceId     dfb 0
NextRotation    dfb 0
PieceX          dfb 0
PieceY          dfb 0
PieceRot        dfb 0
TotalPieces     dfb $47,$04,$03 ; TODO dfw
TotalPiecesBCD  dfb $00,$00,$00
; TryPieceX,Y and Rot are input parameters to DoesPieceFit subroutine
TryPieceX       dfb 0
TryPieceY       dfb 0
TryPieceRot     dfb 0
