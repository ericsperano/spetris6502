;*** InitPtr <Address> <ZP pointer>
.macro          InitPtr addr, ptr
                lda #<addr        ; lo byte
                sta ptr
                lda #>addr        ; hi byte
                sta ptr+1
.endmacro
