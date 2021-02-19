;
; zero page pointers
;
PtrTmp1         equ $06
PtrTmp2         equ $08
PtrPoints       equ $1d
PTR_Piece       equ $ce
PTR_Field       equ $eb
PTR_FieldPos    equ $ed
PTR_ScreenPos   equ $fa
PtrDisplayStr   equ $fc         ; used by the DisplayStr routine

; Tileset Structure Size is 8 bytes
; 8 fields of 1 byte each, in this order:
; box, lines, left bar, right bar, left corner, right corner, bottom bar, background
TilesetSize     equ 9

; Which lines the NextPieceY is displayed
; TODO NextPieceX ?
NextPieceY      equ 12

;
; Apple II Subroutines & I/O Adresses
;
KYBD            equ $c000
STROBE          equ $c010
HOME            equ $fc58
Speaker         equ $c030

;
; Key constants
;
KeyLeftArrow    equ $88
KeyRightArrow   equ $95
KeyUpArrow      equ $8b
KeyDownArrow    equ $8a
KeySpace        equ $a0
KeyEscape       equ $9b
Key1            equ "1"
Key2            equ "2"
Keya            equ "a"
KeyA            equ "A"
Keyn            equ "n"
KeyN            equ "N"
Keyp            equ "p"
KeyP            equ "P"
Keyy            equ "y"
KeyY            equ "Y"
Keyz            equ "z"
KeyZ            equ "Z"