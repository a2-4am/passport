@echo off
if "%1" equ "clean" (
echo y|1>nul rd build /s
goto :EOF
)

setlocal enabledelayedexpansion
set BUILDDISK=build\passport

set ACME=acme
set EXOMIZER=exomizer
set CADIUS=cadius
2>nul md build
cd src\mods
%ACME% universalrwts.a
cd ..\..\build
%EXOMIZER% mem -lnone -q -P23 -f universalrwts.bin@0xb800 -o universalrwts.pak
cd ..\src\mods
%ACME% -r ..\..\build\t00only.lst t00only.a
cd ..\..\build
2>nul del vars.a
%EXOMIZER% mem -lnone -q -P23 -f t00only.bin@0x2000 -o t00only.pak
cd ..\src
2>..\build\out.txt %ACME% -DFORWARD_DECRUNCHING=1 passport.a
for /f "tokens=2,3 delims=)" %%q in ('find "RELBASE =" ..\build\out.txt') do set _make=%%q
2>..\build\out.txt %ACME% -r ..\build\passport.lst -DRELBASE=$%_make:~-4% -DFORWARD_DECRUNCHING=1 passport.a
for /f "tokens=4,* delims=:(" %%q in ('find "SaveProDOS=" ..\build\out.txt') do echo %%q > ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "ThisSlot=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "PrintByID=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "WaitForKey=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "CleanExit=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "GetVolumeName=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "GetVolumeInfo=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "PREFSVER=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "PREFSFILE=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "OpenFile=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "ReadFile=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "CloseFile=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "SLOT=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
for /f "tokens=4,* delims=:(" %%q in ('find "DRIVE=" ..\build\out.txt') do echo %%q >> ..\build\vars.a
cd ..\build
%EXOMIZER% raw -q -P23 -T4 -b passport.tmp -o passport.pak
cd ..\src
%ACME% -DFORWARD_DECRUNCHING=0 wrapper.a
cd ..
1>nul copy res\work.po %BUILDDISK%.po
1>nul copy res\_FileInformation.txt build\
%CADIUS% ADDFILE "%BUILDDISK%.po" "/PASSPORT/" "build\PASSPORT.SYSTEM"
cscript /nologo bin/po2do.js build\ build\
2>nul del "%BUILDDISK%.po"

rem third-party tools required to build (must be in path)
rem https://sourceforge.net/projects/acme-crossass/
rem https://bitbucket.org/magli143/exomizer/wiki/Home
rem https://www.brutaldeluxe.fr/products/crossdevtools/cadius/
rem https://github.com/mach-kernel/cadius
