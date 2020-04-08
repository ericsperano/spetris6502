;
; Increment the speed count.
; If it reaches the speed limit, we force the piece down and refresh the screen
;
IncSpeedCount   MAC
                clc
                lda SpeedCount+1                ; increment SpeedCount (16 bits)
                adc #1
                sta SpeedCount+1
                lda SpeedCount
                adc #0
                sta SpeedCount
                cmp SpeedLimit                  ; 16 bits comparison of SpeedCount and SpeedLimit
                bcc ]1                          ; do nothing if hi byte of SpeedCount is less
                lda SpeedCount+1                ; check low byte
                cmp SpeedLimit+1
                bcc ]1                          ; do nothing if lo byte of SpeedCount is less
                lda #1                          ; we reached speed limit, force piece down and refresh screen
                sta FlagForceDown
                sta FlagRefreshScr
                lda #0                          ; reset SpeedCount
                sta SpeedCount+1
                sta SpeedCount
                <<<
