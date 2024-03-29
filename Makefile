SHELL=/bin/bash -o pipefail
AC:=applecommander
PRODOS_DSK:=spetris.po
DOS_DSK:=spetris.dsk
ASM := Merlin32
ASM_FLAGS := -V
SRC = *.s macro/*.s
OBJ := spetris spetrisb

.PHONY: all

all: $(PRODOS_DSK) $(DOS_DSK)

spetris: $(SRC)
	$(ASM) $(ASM_FLAGS) macro spetris.s

spetrisb: $(SRC)
	$(ASM) $(ASM_FLAGS) macro spetrisb.s

$(PRODOS_DSK): $(OBJ)
	$(AC) -pro140 $(PRODOS_DSK) SPETRIS
	$(AC) -bas $(PRODOS_DSK) spetris < spetris.bas
	$(AC) -p $(PRODOS_DSK) spetris1 bin 0x2000 < spetris
	$(AC) -p $(PRODOS_DSK) spetris2 bin 0x2000 < spetrisb
	$(AC) -p $(PRODOS_DSK) tetris1.mck bin 0x4e20 < soundtrack/tetris1.mck
	$(AC) -p $(PRODOS_DSK) tetris2.mck bin 0x4e20 < soundtrack/tetris2.mck
	$(AC) -p $(PRODOS_DSK) tetris3.mck bin 0x4e20 < soundtrack/tetris3.mck
	$(AC) -p $(PRODOS_DSK) mock.inf bin 0x9182 < soundtrack/mock.inf

$(DOS_DSK): $(OBJ)
	#$(AC) -dos140 $(DOS_DSK) SPETRIS
	cp bootblank.dsk.bkp $(DOS_DSK)
	$(AC) -bas $(DOS_DSK) spetris < spetris.bas
	$(AC) -bas $(DOS_DSK) spetris.bas < spetris.bas
	$(AC) -p $(DOS_DSK) spetris1 bin 0x2000 < spetris
	$(AC) -p $(DOS_DSK) spetris2 bin 0x2000 < spetrisb
	$(AC) -p $(DOS_DSK) tetris1.mck bin 0x4e20 < soundtrack/tetris1.mck
	$(AC) -p $(DOS_DSK) tetris2.mck bin 0x4e20 < soundtrack/tetris2.mck
	$(AC) -p $(DOS_DSK) tetris3.mck bin 0x4e20 < soundtrack/tetris3.mck
	$(AC) -p $(DOS_DSK) mock.inf bin 0x9182 < soundtrack/mock.inf

run:
	osascript "virtual_emulation.scpt"

copy: all
	cp $(PRODOS_DSK) /Volumes/APPLE\ II/SPETRIS.po
	cp $(DOS_DSK) /Volumes/APPLE\ II/SPETRIS.dsk

clean_prodos:
	@rm -rfv $(PRODOS_DSK)

clean_dos:
	@rm -rfv $(DOS_DSK)

clean: clean_prodos clean_dos
	@rm -rfv  $(OBJ) _FileInformation.txt *.log Spetris*_Output.txt *.o
