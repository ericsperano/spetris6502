SHELL=/bin/bash -o pipefail
PRODOS_DSK:=spetris.po
DOS33_DSK:=spetris.dsk
#ASM := Merlin32
#ASM_FLAGS := -V
ASM := ca65
ASM_FLAGS := --cpu 65C02 -W2 -v -t apple2enh
OBJ := spetris

.PHONY: all

all: $(PRODOS_DSK)

spetris:
	$(ASM) $(ASM_FLAGS) Spetris.s -l spetris.lst
	ld65 -t apple2enh -o spetris.bin -C apple2bin.cfg Spetris.o

$(PRODOS_DSK): clean $(OBJ)
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -pro140 $(PRODOS_DSK) SPETRIS
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(PRODOS_DSK) spetris bin 0x2000 < spetris.bin

$(DOS33_DSK): clean $(OBJ)
	#java -jar ~/bin/AppleCommander-ac-1.6.0.jar -dos140 $(DOS33_DSK) SPETRIS
	#java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(DOS33_DSK) spetris bin 0x300 < spetris
	#java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(DOS33_DSK) spetrisb bin 0x300 < spetrisb

run:
	osascript "virtual_emulation.scpt"

copy: all
	cp $(PRODOS_DSK) /Volumes/APPLE\ II/SPETRIS.po

clean:
	@rm -rfv $(PRODOS_DSK) $(DOS33_DSK) $(OBJ) _FileInformation.txt *.log Spetris*_Output.txt
