#
# Passport Makefile
# assembles source code, optionally builds a disk image and mounts it
#
# original by Quinn Dunki on 2014-08-15
# One Girl, One Laptop Productions
# http://www.quinndunki.com/blondihacks
#
# adapted by 4am on 2017-01-07
#

# third-party tools required to build
# https://sourceforge.net/projects/acme-crossass/
ACME=acme
# https://www.brutaldeluxe.fr/products/crossdevtools/cadius/
# https://github.com/mach-kernel/cadius
CADIUS=cadius
# https://bitbucket.org/magli143/exomizer/wiki/Home
# requires Exomizer 3.0 or later
EXOMIZER=exomizer raw -q -P23

BUILDDISK=build/passport

asm:
	mkdir -p build
	cd src/mods && $(ACME) universalrwts.a
	$(EXOMIZER) build/universalrwts.bin -o build/universalrwts.tmp
	printf "\xB8\x00" | cat - build/universalrwts.tmp > build/universalrwts.pak
	cd src/mods && $(ACME) -r ../../build/t00only.lst t00only.a
	$(EXOMIZER) build/t00only.bin -o build/t00only.tmp
	printf "\x20\x00" | cat - build/t00only.tmp > build/t00only.pak
	cd src && $(ACME) -r ../build/passport.lst -DFORWARD_DECRUNCHING=1 passport.a 2> ../build/relbase.log
	cd src && $(ACME) -DRELBASE=`cat ../build/relbase.log | grep "RELBASE =" | cut -d"=" -f2 | cut -d"(" -f2 | cut -d")" -f1` -DFORWARD_DECRUNCHING=1 passport.a 2> ../build/vars.log
	grep "ThisSlot=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "PrintByID=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "WaitForKey=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "CleanExit=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "OpenFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "ReadFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "CloseFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "GetVolumeName=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "GetVolumeInfo=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "PREFSVER=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "PREFSFILE=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "SLOT=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep "DRIVE=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	$(EXOMIZER) -b build/passport.tmp -o build/passport.pak
	cd src && $(ACME) -DFORWARD_DECRUNCHING=0 wrapper.a
	cp res/work.po "$(BUILDDISK)".po
	cp res/_FileInformation.txt build/
	$(CADIUS) ADDFILE "${BUILDDISK}".po "/PASSPORT/" "build/PASSPORT.SYSTEM"
	bin/po2do.py build/ build/
	rm "$(BUILDDISK)".po

clean:
	rm -rf build/

mount:
	open "$(BUILDDISK)".dsk

all: clean asm mount
