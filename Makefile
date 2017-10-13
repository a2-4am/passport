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
ACME=`which acme`
# https://sourceforge.net/projects/applecommander/
AC=bin/AppleCommander.jar

BUILDDISK=build/passport.po

asm:
	mkdir -p build
	cd src/mods && $(ACME) universalrwts.a && cd -
	exomize raw mods/universalrwts.bin -o mods/universalrwts.pak
	#prepend big-endian load address
	cd src/mods && $(ACME) t00only.a && cd -
	exomize raw mods/t00only.bin -o mods/t00only.pak
	#prepend big-endian load address
	cd src && $(ACME) passport.a && cd -
	#capture value following "RELBASE = "
	#cd src && $(ACME) -DRELBASE=value passport.a && cd -
	cp res/work.po $(BUILDDISK)
	java -jar $(AC) -p $(BUILDDISK) "PASSPORT.SYSTEM" sys 0x2000 < build/PASSPORT.SYSTEM

clean:
	rm -rf build/

mount:
	osascript bin/V2Make.scpt "`pwd`" $(BUILDDISK)

all: clean asm mount
