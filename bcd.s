;
; DisplayBCD
; reuse dsStrLen from DisplayStr as temporary storage
;
DisplayBCD      ldy #0
                sty ddSignif                    ; significant zero flag
                lda (PtrDisplayStr),y           ; lo byte of the screen adress
                sta PTR_ScreenPos
                iny
                lda (PtrDisplayStr),y           ; hi byte of the screen adress
                sta PTR_ScreenPos+1
                iny
                lda (PtrDisplayStr),y           ; number length
                sta dsStrLen
                clc
                lda PtrDisplayStr               ; add 3 to lo byte of struct pointer to point to number
                adc #$3
                sta PtrDisplayStr               ; save new lo byte
                lda PtrDisplayStr+1
                adc #$0                         ; will add 1 if the previous add set the carry flag
                sta PtrDisplayStr+1             ; save hi byte
                ldy #0
                ldx #1
]loop0          lda (PtrDisplayStr),y           ; load the byte to display
                DO ]APPLE2E
                phy                             ; save y and a
                ELSE
                sty ddTmpY
                FIN
                pha
                tya                             ; multiply y by 2
                asl
                tay
                pla                             ; reset a, and keep a copy
                ; hi 4 bits
                pha
                clc
                lsr                             ; shift right by 4
                lsr
                lsr
                lsr
                bne ddGrZero1                   ; branch if a is > 0
                lda ddSignif                    ; check if we have hit a significant 0 yet
                beq ddSpace1                    ; no, print space
                lda #0                          ; yes print 0
                bra ddBcd2Asc1
ddSpace1        lda #" "
                bra ddWrite1
ddGrZero1       inc ddSignif                    ; setting the flag to a non zero value
ddBcd2Asc1      clc
                adc #$b0
ddWrite1        sta (PTR_ScreenPos),y           ; write the character
                iny                             ; next position on screen
                ; lo 4 bits
                pla                             ; restore original byte
                and #$0f                        ; keep the lo 4 bits
                bne ddGrZero2                   ; branch if a is > 0
                lda ddSignif                    ; check if we have hit a significant 0 yet
                beq ddSpace2                    ; no, print space
ddPr0           lda #0                          ; yes print 0
                bra ddBcd2Asc2
ddSpace2        cpx dsStrLen                    ; compare x, which is y + 1 with length, last 0 should be printed
                beq ddPr0
                lda #" "
                bra ddWrite2
ddGrZero2       inc ddSignif                    ; setting the flag to a non zero value
ddBcd2Asc2      clc
                adc #$b0
ddWrite2        sta (PTR_ScreenPos),y           ; write the character
                DO ]APPLE2E
                ply                             ; restore y
                ELSE
                ldy ddTmpY
                FIN
                iny                             ; next byte to display
                inx                             ;
                cpy dsStrLen
                bne ]loop0                      ; keep looping
                rts
ddSignif        dfb 0
                DO ]APPLE2E
                ELSE
ddTmpY          dfb 0
                FIN
