SHELL=/bin/bash -o pipefail
DSK:=spetris.po
ASM := Merlin32
ASM_FLAGS := -V
OBJ := spetris spetrisb

.PHONY: all

all: $(DSK)

spetris:
	$(ASM) $(ASM_FLAGS) macro Spetris.s

spetrisb:
	$(ASM) $(ASM_FLAGS) macro Spetrisb.s

$(DSK): clean $(OBJ)
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -pro140 $(DSK) SPETRIS
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(DSK) spetris bin 0x2000 < spetris
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(DSK) spetrisb bin 0x2000 < spetrisb

run:
	osascript "virtual_emulation.scpt"

copy: all
	cp $(DSK) /Volumes/APPLE\ II/SPETRIS.po

clean:
	@rm -rfv $(DSK) $(OBJ) _FileInformation.txt *.log Spetris*_Output.txt
