; Check1Key
;
; ]1 = Key #1 (will automatically test for both case of this key)
; ]2 = Branch if test successful
; ]3 = Branch if test unsuccessful
Check1Key       MAC
                cmp #]1
                beq ]2
                cmp #{]1-$20}
                beq ]2
                jmp ]3
                <<<
; Check2Keys
;
; ]1 = Key #1
; ]2 = Key #2 (will automatically test for both case of this key)
; ]3 = Branch if test successful
; ]4 = Branch if test unsuccessful
Check2Keys      MAC
                cmp #]1
                beq ]3
                cmp #]2
                beq ]3
                cmp #{]2-$20}
                beq ]3
                jmp ]4
                <<<
