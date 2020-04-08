#SHELL=/bin/bash -o pipefail
#DSK:=spetris.dsk
#SRC := spetris.asm
#ASM := lwasm
#ASM_FLAGS := -9bl -p cd
#OBJ := ${SRC:asm=bin}
#ROM := ${SRC:asm=rom}
#MAME := mame
#MAME_ARGS := coco3 -window -nomax -flop1

#.PHONY: all

#all: $(DSK)
all:
	Merlin32 -V . beep.s
	rm -f beep.po
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -pro140 beep.po BEEP
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -p beep.po beep bin 0x300 < beep
	java -jar ~/bin/AppleCommander-ac-1.6.0.jar -l beep.po

run:
	osascript "virtual_emulation.scpt"

#$(DSK) : $(OBJ)
#	rm -f $(DSK)
#	decb dskini $(DSK)
#	decb copy -0 -a -t -r autoexec.bas $(DSK),AUTOEXEC.BAS
#	decb copy -0 -a -t -r autoexec.bas $(DSK),SPETRIS.BAS
#	decb copy -2 -b -r $(SRC) $(DSK),SPETRIS.ASM
#	decb copy -2 -b -r $(OBJ) $(DSK),SPETRIS.BIN

#%.bin: %.asm Makefile
#	$(ASM) $(ASM_FLAGS) -o $@ $< | tee $<.log

#%.rom: %.asm Makefile
#	$(ASM) -9 -p cd -r -o $@ $<

#run: all
#	$(MAME) $(MAME_ARGS) $(DSK)

#debug: $(ROM)
#	$(MAME) -debug -debugscript debugscript coco3 -skip_gameinfo -ui_active -window -nomax

#copy: all
#	cp $(DSK) /Volumes/COCO3/

#clean:
#	@rm -rfv $(DSK) $(OBJ) $(ROM) *.log
