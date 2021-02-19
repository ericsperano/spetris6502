;
; DisplayStr
;
DisplayStr      ldy #$00
                lda (PtrDisplayStr),y           ; lo byte of the screen adress
                sta PtrScreenPos
                iny
                lda (PtrDisplayStr),y           ; hi byte of the screen adress
                sta PtrScreenPos+1
                iny
                lda (PtrDisplayStr),y           ; string length
                sta tmp1
                clc                             ; clear carry flag
                lda PtrDisplayStr               ; add 3 to lo byte of struct pointer to point to text
                adc #$3
                sta PtrDisplayStr               ; save new lo byte
                lda PtrDisplayStr+1
                adc #$0                         ; will add 1 if the previous add set the carry flag
                sta PtrDisplayStr+1             ; save hi byte
                ldy #$00
]loop           lda (PtrDisplayStr),y           ; get char to display
                sta (PtrScreenPos),y            ; copy to screen
                iny
                cpy tmp1
                bne ]loop
                rts
