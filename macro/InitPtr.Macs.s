*** InitPtr <Address> <ZP pointer>
InitPtr         MAC
                *lda #<]1        ; lo byte
                sta ]2
                *lda #>]1        ; hi byte
                *sta ]2+1
                <<<
