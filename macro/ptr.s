;
; InitPtr <Address> <ZP pointer>
;
InitPtr         MAC
                lda #<]1        ; lo byte
                sta ]2
                lda #>]1        ; hi byte
                sta ]2+1
                <<<
;
; CopyPtr <Src> <Dest>
;
CopyPtr         MAC
                lda ]1+1
                sta ]2+1
                lda ]1
                sta ]2
                <<<
;
;
;
InitZeroTable   MAC
                InitPtr PointsTable;PtrPoints   ; init constant zero page pointers
                InitPtr Field;PtrField
                <<<
