InitPtrFieldPos MAC
                lda #<FieldPositions
                sta PTR_FieldPos
                lda #>FieldPositions
                sta PTR_FieldPos+1
                <<<
