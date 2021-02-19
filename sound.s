;
; Pitch in X, Duration in Y
;
PlaySound       phy
                phx
]loop           plx
                phx
                lda Speaker
]delay          dex
                bne ]delay
                dey
                bne ]loop
                plx
                ply
                rts
;
;
;
PointsSounds
                ldx #0
]loop0          stx tmp1
]loop1          lda Notes,x
                tax
                ldy #20
                jsr PlaySound
                ldx #30
]sleep          jsr Sleep
                dex
                bne ]sleep
:next           ldx tmp1
                inx
                cpx LinesCount
                bne ]loop0
:end            rts
Notes           dfb 250, 220, 190, 160
