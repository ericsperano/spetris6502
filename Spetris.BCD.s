***
*** DisplayBCD
*** reuse dsStrLen from DisplayStr as temporary storage
***
DisplayBCD      ldy #0
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
                ldx #0
dbcdLoop0       lda (PtrDisplayStr),y
                phy
                pha
                tya
                asl
                tay
                pla
                pha
                lsr
                lsr
                lsr
                lsr
                and #$0f
                clc
                adc #$b0
                sta (PTR_ScreenPos),y
                iny
                pla
                and #$0f
                adc #$b0
                sta (PTR_ScreenPos),y
                ply
                iny
                inx
                cpx dsStrLen
                bne dbcdLoop0
                rts
