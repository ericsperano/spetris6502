***
*** SPETRIS FOR THE APPLE II COMPUTER
***
*** Compile Flags:
]USE_EXT_CHAR = 0 ; disable the use of the extended char set
                org $300
                put Spetris.Main
                put Spetris.BCD
                put Spetris.Str
                put Spetris.Char
                put Spetris.Random
                put Spetris.Keyboard
                put Spetris.Level
                put Spetris.Piece
                put Spetris.Field
                put Spetris.Score
                put Spetris.Screen
                put Spetris.Sleep
                put Spetris.Splash
