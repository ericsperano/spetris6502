# Spétris6502

A simple text based Tetris clone written in 6502 assembler for the Apple II Computer.
This is meant to be just a little fun learning project to teach myself 6502 assembler for a computer of my childhood.

Largely based on this excellent tutorial from Javidx9 on how to write a text mode Tetris clone in C++ for Windows:

* https://www.youtube.com/watch?v=8OK8_tHeCIA

* https://github.com/OneLoneCoder/videos/blob/master/OneLoneCoder_Tetris.cpp

## Build

Install the [Merlin32](https://brutaldeluxe.fr/products/crossdevtools/merlin/) assembler from brutaldeluxe.fr

Just run:

    make

And it will provide you a spetris.po (ProDOS disk) and a spetris.dsk (Old DOS) disks

On each disk, there will be two binaries:

1) `spetris1`: Spetris with 65c02 opcodes and MouseText characters.
2) `spetris2`: 6502 opcodes only and regular ASCII characters.

## Other implementation

For the Color Computer: https://github.com/esperano/spetris6809

## Soundtracks

Big thanks to Tom Porter for providing 3 Tetris mockingboard soundtracks.
