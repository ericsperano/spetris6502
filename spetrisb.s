;
; SPETRIS FOR THE APPLE II COMPUTER
;
; Compile Flags:
]APPLE2E = 0 ; will disable mouse text and use 6502 instructions
bra             MAC
                jmp ]1
                <<<
phx             MAC
                txa
                pha
                <<<
plx             MAC
                pla
                tax
                <<<
phy             MAC
                tya
                pha
                <<<
ply             MAC
                pla
                tay
                <<<
TotalTilesets   equ 3
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
