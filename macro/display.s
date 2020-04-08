;
;
;
AltCharSetOn    MAC
                DO ]APPLE2E
                sta ALTCHARSETON                ; enable alternate char set
                FIN
                <<<
AltCharSetOff   MAC
                DO ]APPLE2E
                sta ALTCHARSETOFF               ; disable alternate char set
                FIN
                <<<
ALTCHARSETON    equ $c00f
ALTCHARSETOFF   equ $c00e
;
;
;
JSRDisplayBCD   MAC
                InitPtr ]1;PtrDisplayStr
                jsr DisplayBCD
                <<<
;
;
;
JSRDisplayStr   MAC
                InitPtr ]1;PtrDisplayStr
                jsr DisplayStr
                <<<
