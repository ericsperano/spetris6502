;
; zero page pointers
;
PtrTmp1         equ $06
PtrTmp2         equ $08
PtrPoints       equ $1d
PtrPiece        equ $ce
PtrField        equ $eb
PtrFieldPos     equ $ed
PtrScreenPos    equ $fa
PtrDisplayStr   equ $fc         ; used by the DisplayStr routine

; Tileset Structure Size is 8 bytes
; 8 fields of 1 byte each, in this order:
; box, lines, left bar, right bar, left corner, right corner, bottom bar, background
TilesetSize     equ 9

; col and row of where the next piece is displayed
NextPieceX      equ 16
NextPieceY      equ 12

;
; Apple II Subroutines & I/O Adresses
;
KYBD            equ $c000
STROBE          equ $c010
HOME            equ $fc58
SPEAKER         equ $c030
ALTCHARSETON    equ $c00f
ALTCHARSETOFF   equ $c00e

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
Keyb            equ "b"
KeyB            equ "B"
Keyh            equ "h"
KeyH            equ "H"
Keym            equ "m"
KeyM            equ "M"
Keyn            equ "n"
KeyN            equ "N"
Keyp            equ "p"
KeyP            equ "P"
Keyy            equ "y"
KeyY            equ "Y"
;
;
;
FieldCols       equ 14
FieldRows       equ 17
;
;
;
ChTransparent   equ '.'
PieceLen        equ 16
PieceStructLen  equ 4 * PieceLen                  ; 4 different rotations
;
;
;
SleepTime       equ $ff
