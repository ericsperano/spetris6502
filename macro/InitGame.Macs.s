***
***
***
InitGame        MAC
                lda #0
                sta FlagQuitGame
                sta SpeedCount+1
                sta SpeedCount
                sta ScoreBCD
                sta ScoreBCD+1
                sta ScoreBCD+2
                sta ScoreBCD+3
                sta TotalLinesBCD
                sta TotalLinesBCD+1
                sta TotalPiecesBCD
                sta TotalPiecesBCD+1
                sta TotalPiecesBCD+2
                sta CurrCharset
                sta SpeedLimit+1
                lda #02
                sta SpeedLimit
                lda #1
                sta FlagRefreshScr
                sta LevelBCD
                <<<
