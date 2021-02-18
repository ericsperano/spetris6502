.macro          JSRDisplayStr addr
                InitPtr addr, PtrDisplayStr
                jsr DisplayStr
.endmacro
