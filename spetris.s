;;;
;;; SPETRIS FOR THE APPLE IIe COMPUTER
;;;
;;; Compile Flags:
]APPLE2E = 1 ; will enable mouse text and 65c02 extra instructions
TotalTilesets   equ 12
                org $2000
                put constants
                put main
                put bcd
                put field
                put keyboard
                put level
                put piece
                put random
                put score
                put screen
                put sleep
                put sound
                put splash
                put string
                put tileset
