;***
;***
;***
MTChTile        = $7f
MTChLines       = $ff
MTChLB          = $5a
MTChRB          = $5f
MTChLC          = ASCII_Space
MTChRC          = ASCII_Space
MTChBB          = $4c
MTChBG          = ASCII_Space
UseMTCharset:   lda #MTChTile
                sta CharTile
                lda #MTChLines
                sta CharLines
                lda #MTChLB
                sta CharLB
                lda #MTChRB
                sta CharRB
                lda #MTChLC
                sta CharLC
                lda #MTChRC
                sta CharRC
                lda #MTChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #MTChBG
                sta CharBG
                rts
;***
;***
;***
MT2ChTile       = $ff
MT2ChLines      = $7f
MT2ChLB         = ASCII_Space
MT2ChRB         = ASCII_Space
MT2ChLC         = ASCII_Space
MT2ChRC         = ASCII_Space
MT2ChBB         = ASCII_Space
MT2ChBG         = ASCII_Space + $80
UseMT2Charset:  lda #MT2ChTile
                sta CharTile
                lda #MT2ChLines
                sta CharLines
                lda #MT2ChLB
                sta CharLB
                lda #MT2ChRB
                sta CharRB
                lda #MT2ChLC
                sta CharLC
                lda #MT2ChRC
                sta CharRC
                lda #MT2ChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #MT2ChBG
                sta CharBG
                rts
;***
;***
;***
MT3ChTile       = $40
MT3ChLines      = $41
MT3ChLB         = $5a
MT3ChRB         = $5f
MT3ChLC         = ASCII_Space
MT3ChRC         = ASCII_Space
MT3ChBB         = $4c
MT3ChBG         = ASCII_Space
UseMT3Charset:  lda #MT3ChTile
                sta CharTile
                lda #MT3ChLines
                sta CharLines
                lda #MT3ChLB
                sta CharLB
                lda #MT3ChRB
                sta CharRB
                lda #MT3ChLC
                sta CharLC
                lda #MT3ChRC
                sta CharRC
                lda #MT3ChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #MT3ChBG
                sta CharBG
                rts
;***
;***
;***
MT4ChTile       = $56
MT4ChLines      = $5d
MT4ChLB         = $5a
MT4ChRB         = $5f
MT4ChLC         = ASCII_Space
MT4ChRC         = ASCII_Space
MT4ChBB         = $4c
MT4ChBG         = ASCII_Space
UseMT4Charset:  lda #MT4ChTile
                sta CharTile
                lda #MT4ChLines
                sta CharLines
                lda #MT4ChLB
                sta CharLB
                lda #MT4ChRB
                sta CharRB
                lda #MT4ChLC
                sta CharLC
                lda #MT4ChRC
                sta CharRC
                lda #MT4ChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #MT4ChBG
                sta CharBG
                rts
;***
;***
;***
RegChTile       = ASCII_Hash + $80
RegChLines      = ASCII_Equal
RegChLB         = ASCII_Exclam
RegChRB         = ASCII_Exclam
RegChLC         = ASCII_Plus
RegChRC         = ASCII_Plus
RegChBB         = ASCII_Dash
RegChBG         = ASCII_Space
UseRegCharset:  lda #RegChTile
                sta CharTile
                lda #RegChLines
                sta CharLines
                lda #RegChLB
                sta CharLB
                lda #RegChRB
                sta CharRB
                lda #RegChLC
                sta CharLC
                lda #RegChRC
                sta CharRC
                lda #RegChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #RegChBG
                sta CharBG
                rts
;***
;***
;***
Reg2ChTile      = ASCII_Hash
Reg2ChLines     = ASCII_Dash
Reg2ChLB        = ASCII_Space
Reg2ChRB        = ASCII_Space
Reg2ChLC        = ASCII_Space
Reg2ChRC        = ASCII_Space
Reg2ChBB        = ASCII_Space
Reg2ChBG        = ASCII_Space + $80
UseReg2Charset: lda #Reg2ChTile
                sta CharTile
                lda #Reg2ChLines
                sta CharLines
                lda #Reg2ChLB
                sta CharLB
                lda #Reg2ChRB
                sta CharRB
                lda #Reg2ChLC
                sta CharLC
                lda #Reg2ChRC
                sta CharRC
                lda #Reg2ChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #Reg2ChBG
                sta CharBG
                rts
;***
;***
;***
ASCII_Hash      = $23
ASCII_Dash      = $2d
ASCII_Space     = $20
ASCII_Plus      = $2b
ASCII_Exclam    = $21
ASCII_Equal     = $3d
ASCII_y         = $79
ASCII_n         = $6e
CharTile:       .byte 0
CharLines:      .byte 0
CharLB:         .byte 0
CharRB:         .byte 0
CharLC:         .byte 0
CharRC:         .byte 0
CharBB:         .byte 0
CharBG:         .byte 0
OldCharBG:      .byte 0
CurrCharset:    .byte 0
