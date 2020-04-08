;
; Sleep
;
                DO ]APPLE2E
Sleep           phx
                ldx #SleepTime
]loop           dex
                bne ]loop
                plx
                ELSE
Sleep           pha
                txa
                pha
                ldx #SleepTime
]loop           dex
                bne ]loop
                pla
                tax
                pla
                FIN
                rts
SleepTime       equ $ff
