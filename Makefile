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
EXOMIZER=exomizer

BUILDDISK=build/passport

asm:
	mkdir -p build
	cd src/mods && $(ACME) universalrwts.a
	$(EXOMIZER) mem -lnone -q -P23 -f build/universalrwts.bin@0xb800 -o build/universalrwts.pak
	cd src/mods && $(ACME) -r ../../build/t00only.lst t00only.a
	$(EXOMIZER) mem -lnone -q -P23 -f build/t00only.bin@0x2000 -o build/t00only.pak
	echo > build/vars.a
	cd src && $(ACME) -r ../build/passport.lst -DFORWARD_DECRUNCHING=1 passport.a 2> ../build/relbase.log
	cd src && $(ACME) -r ../build/passport.lst -DRELBASE=`cat ../build/relbase.log | grep "RELBASE =" | cut -d"=" -f2 | cut -d"(" -f2 | cut -d")" -f1` -DFORWARD_DECRUNCHING=1 passport.a 2> ../build/vars.log
	grep -m1 "ThisSlot=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "PrintByID=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "WaitForKey=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "CleanExit=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "OpenFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "ReadFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "CloseFile=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "GetVolumeName=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "GetVolumeInfo=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "PREFSVER=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "PREFSFILE=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "SLOT=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "DRIVE=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "MainMenu=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	grep -m1 "CheckCache=" build/vars.log | cut -d":" -f3 | cut -d"(" -f1 >> build/vars.a
	$(EXOMIZER) raw -q -P23 -b build/passport.tmp -o build/passport.pak
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
