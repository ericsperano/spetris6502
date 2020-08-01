            ORG     $800
HOME        EQU     $FC58
            *
Start       JSR     DispIntro
INFINITE    JMP     INFINITE
End         RTS

DispIntro   LDX     #0
            LDY     #0
LOOP        LDA     Intro,X
            STA     $400,Y
            INX
            INY
            CPY     #120
            BNE     LOOP
            RTS

Intro       ASC     "             S P E T R I S !            "      ; 1
            ASC     "                                        "      ; 2
            ASC     "Choose Display Mode:                    "      ; 3
            ASC     "                                        "      ; 4
            ASC     "[C]OLOR                                 "      ; 5
            ASC     "[M]ONOCHROME                            "      ; 6
            ASC     "                                        "      ; 7
            ASC     "KEYBOARD GAME CONTROLS:                 "      ; 8
            ASC     "                                        "      ; 9
            ASC     "LEFT ARROW      MOVE PIECE LEFT         "      ; 10
            ASC     "RIGHT ARROW     MOVE PIECE RIGHT        "      ; 11
            ASC     "UP ARROW        ROTATE PIECE            "      ; 12
            ASC     "DOWN ARROW      MOVE PIECE DOWN         "      ; 13
            ASC     "SPACE BAR       DROP PIECE              "      ; 14
            ASC     "P               PAUSE GAME              "      ; 15
            ASC     "BREAK           EXIT GAME               "      ; 16
