SHELL=/bin/bash -o pipefail
DSK:=spetris.po
ASM := Merlin32
ASM_FLAGS := -V .
OBJ := spetris

.PHONY: all

all: $(DSK)

spetris:
	$(ASM) $(ASM_FLAGS) spetris.s

$(DSK): clean $(OBJ)
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -pro140 $(DSK) SPETRIS
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p $(DSK) spetris bin 0x2000 < spetris

run:
	osascript "virtual_emulation.scpt"

copy: all
	cp $(DSK) /Volumes/APPLE\ II/SPETRIS.po

clean:
	@rm -rfv $(DSK) $(OBJ) _FileInformation.txt *.log
