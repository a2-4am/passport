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
# https://sourceforge.net/projects/applecommander/
AC=bin/AppleCommander.jar
# https://bitbucket.org/magli143/exomizer/wiki/Home
# requires Exomizer 3.0 or later
EXOMIZER=exomizer raw -P0 -q

BUILDDISK=build/passport.po

asm:
	mkdir -p build
	cd src/mods && $(ACME) universalrwts.a
	$(EXOMIZER) build/universalrwts.bin -o build/universalrwts.tmp
	printf "\xB8\x00" | cat - build/universalrwts.tmp > build/universalrwts.pak
	cd src/mods && $(ACME) -r ../../build/t00only.lst t00only.a
	$(EXOMIZER) build/t00only.bin -o build/t00only.tmp
	printf "\x20\x00" | cat - build/t00only.tmp > build/t00only.pak
	cd src && $(ACME) -r ../build/passport.lst passport.a 2> ../build/relbase.log
	cd src && $(ACME) -DRELBASE=`cat ../build/relbase.log | cut -d"=" -f2 | cut -d"(" -f2 | cut -d")" -f1` passport.a
	cp res/work.po $(BUILDDISK)
	java -jar $(AC) -p $(BUILDDISK) "PASSPORT.SYSTEM" sys 0x2000 < build/PASSPORT.SYSTEM

clean:
	rm -rf build/

mount:
	osascript bin/V2Make.scpt "`pwd`" $(BUILDDISK)

all: clean asm mount
