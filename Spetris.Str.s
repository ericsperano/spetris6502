***
*** DisplayStr
***
DisplayStr      ldy #$00
                lda (PtrDisplayStr),y           ; lo byte of the screen adress
                sta PTR_ScreenPos
                iny
                lda (PtrDisplayStr),y           ; hi byte of the screen adress
                sta PTR_ScreenPos+1
                iny
                lda (PtrDisplayStr),y           ; string length
                sta dsStrLen
                clc                             ; clear carry flag
                lda PtrDisplayStr               ; add 3 to lo byte of struct pointer to point to text
                adc #$3
                sta PtrDisplayStr               ; save new lo byte
                lda PtrDisplayStr+1
                adc #$0                         ; will add 1 if the previous add set the carry flag
                sta PtrDisplayStr+1             ; save hi byte
                ldy #$00
dsLoop          lda (PtrDisplayStr),y           ; get char to display
                sta (PTR_ScreenPos),y           ; copy to screen
                iny
                cpy dsStrLen
                bne dsLoop
                rts
dsStrLen        dfb 0                           ; copy of the current string length
