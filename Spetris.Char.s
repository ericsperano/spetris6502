***
*** TODO move to macro
***
UseCharset      MAC
                lda #]1ChTile
                sta CharTile
                lda #]1ChLines
                sta CharLines
                lda #]1ChLB
                sta CharLB
                lda #]1ChRB
                sta CharRB
                lda #]1ChLC
                sta CharLC
                lda #]1ChRC
                sta CharRC
                lda #]1ChBB
                sta CharBB
                lda CharBG
                sta OldCharBG
                lda #]1ChBG
                sta CharBG
                <<<
***
***
***
MTChTile        equ $7f
MTChLines       equ $ff
MTChLB          equ $5a
MTChRB          equ $5f
MTChLC          equ " "
MTChRC          equ " "
MTChBB          equ $4c
MTChBG          equ " "
UseMTCharset    UseCharset MT
                rts
***
***
***
MT2ChTile       equ $ff
MT2ChLines      equ $7f
MT2ChLB         equ " "
MT2ChRB         equ " "
MT2ChLC         equ " "
MT2ChRC         equ " "
MT2ChBB         equ " "
MT2ChBG         equ ' '
UseMT2Charset   UseCharset MT2
                rts
***
***
***
MT3ChTile       equ $40
MT3ChLines      equ $41
MT3ChLB         equ $5a
MT3ChRB         equ $5f
MT3ChLC         equ " "
MT3ChRC         equ " "
MT3ChBB         equ $4c
MT3ChBG         equ " "
UseMT3Charset   UseCharset MT3
                rts
***
***
***
MT4ChTile       equ $56
MT4ChLines      equ $5d
MT4ChLB         equ $5a
MT4ChRB         equ $5f
MT4ChLC         equ " "
MT4ChRC         equ " "
MT4ChBB         equ $4c
MT4ChBG         equ " "
UseMT4Charset   UseCharset MT4
                rts
***
***
***
UseRegCharset   UseCharset Reg
                rts
RegChTile       equ '#'
RegChLines      equ "="
RegChLB         equ "|"
RegChRB         equ "|"
RegChLC         equ "+"
RegChRC         equ "+"
RegChBB         equ "-"
RegChBG         equ " "
***
***
***
UseReg2Charset  UseCharset Reg2
                rts
Reg2ChTile      equ "#"
Reg2ChLines     equ '-'
Reg2ChLB        equ " "
Reg2ChRB        equ " "
Reg2ChLC        equ " "
Reg2ChRC        equ " "
Reg2ChBB        equ " "
Reg2ChBG        equ ' '
***
***
***
CharTile        dfb 0
CharLines       dfb 0
CharLB          dfb 0
CharRB          dfb 0
CharLC          dfb 0
CharRC          dfb 0
CharBB          dfb 0
CharBG          dfb 0
OldCharBG       dfb 0
TotalMTSets     equ 4
TotalRegSets    equ 2
CurrCharset     dfb 0
