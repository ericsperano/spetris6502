.macro          JSRDisplayBCD addr
                InitPtr addr,PtrDisplayStr
                jsr DisplayBCD
.endmacro
