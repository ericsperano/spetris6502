* SPETRIS FOR APPLE II COMPUTERS
                ORG     $2000
*
HOME            EQU     $FC58
TEXTON          EQU     $C051
80COLOFF        EQU     $C00C
80COLON         EQU     $C00D
PTR1            EQU     $06
PTR2            EQU     $08
PTR3            EQU     $1D
PTR4            EQU     $CE
PTR5            EQU     $EB
PTR6            EQU     $ED
PTR_ScreenPos   EQU     $FA
PTR_DisplayLine EQU     $FC
*
MDisplayLine    MAC
                LDA     #<]1                    ; lo byte of struct to display
                STA     PTR_DisplayLine
                LDA     #>]1                    ; hi byte of struct to display
                STA     PTR_DisplayLine+1
                JSR     DisplayLine
                <<<
*
                STA     80COLOFF
                STA     TEXTON
                *STA     80COLOFF
                JSR     HOME
                MDisplayLine INTRO00
                MDisplayLine INTRO01
                MDisplayLine INTRO02
                MDisplayLine INTRO03
                MDisplayLine INTRO04
                MDisplayLine INTRO05
                MDisplayLine INTRO06
                MDisplayLine INTRO07
                MDisplayLine INTRO08
                MDisplayLine INTRO09
END             JMP     END
*
DisplayLine     LDY     #$00
                LDA     (PTR_DisplayLine),Y     ; lo byte of the screen adress
                STA     PTR_ScreenPos
                INY
                LDA     (PTR_DisplayLine),Y     ; hi byte of the screen adress
                STA     PTR_ScreenPos+1
                INY
                LDA     (PTR_DisplayLine),Y     ; string length
                STA     DLStrLen
                CLC                             ; clear carry flag
                LDA     PTR_DisplayLine         ; add 3 to lo byte of struct pointer to point to text to print
                ADC     #$3
                STA     PTR_DisplayLine         ; save new lo byte
                LDA     PTR_DisplayLine+1
                ADC     #$0                     ; will add 1 if the previous add set the carry flag
                STA     PTR_DisplayLine+1       ; save hi byte
                LDY     #$00
DisplayLineLoop LDA     (PTR_DisplayLine),Y     ; get char to display
                STA     (PTR_ScreenPos),Y       ; copy to screen
                INY
                CPY     DLStrLen
                BNE     DisplayLineLoop
                RTS
DLStrLen        DFB     0 ; use the stack instead?

INTRO00         DFB     $0d,$04,15
                ASC     "S P E T R I S !"
INTRO01         DFB     $08,$05,24
                ASC     "For "
                DFB     $40
                ASC     " Apple II Computers"
INTRO02         DFB     $09,$07,22
                ASC     "Keyboard Game Controls"
INTRO03         DFB     $ad,$04,29
                ASC     "Left Arrow:   Move piece left"
INTRO04         DFB     $2d,$05,30
                ASC     "Right Arrow:  Move piece right"
INTRO05         DFB     $ad,$05,26
                ASC     "Up Arrow:     Rotate piece"
INTRO06         DFB     $2d,$06,29
                ASC     "Down Arrow:   Move piece down"
INTRO07         DFB     $ad,$06,24
                ASC     "Space Bar:    Drop piece"
INTRO08         DFB     $2d,$07,24
                ASC     "P:            Pause game"
INTRO09         DFB     $ad,$07,23
                ASC     "Esc:          Quit game"
