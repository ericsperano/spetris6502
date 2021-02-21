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
;
;
;
SetFlagRefresh  MAC
                ldx #1                          ; and refresh screen
                stx FlagRefreshScr
                <<<
