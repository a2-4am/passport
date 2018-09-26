0</* :
@echo off
if "%1" equ "clean" (
echo y|1>nul rd build /s
goto :EOF
)
set ACME=acme
set EXOMIZER=exomize
set CADIUS=cadius
2>nul md build
cd src\mods
%ACME% universalrwts.a
cd ..\..\build
%EXOMIZER% raw -q universalrwts.bin -o universalrwts.tmp
cscript /nologo //e:jscript %~f0 "b8" "00"
1>nul copy /b tmp+universalrwts.tmp universalrwts.pak
cd ..\src\mods
%ACME% -r ..\..\build\t00only.lst t00only.a
cd ..\..\build
%EXOMIZER% raw -q t00only.bin -o t00only.tmp
cscript /nologo //e:jscript %~f0 "20" "00"
1>nul copy /b tmp+t00only.tmp t00only.pak
cd ..\src
for /f "tokens=*" %%q in ('2^>^&1 %ACME% passport.a') do set _make=%%q
%ACME% -r ..\build\passport.lst -DRELBASE=$%_make:~-5,4% passport.a
set _make=
cd ..
1>nul copy res\work.po build\passport.po
1>nul copy res\_FileInformation.txt build\
%CADIUS% ADDFILE "build\passport.po" "/PASSPORT/" "build\PASSPORT.SYSTEM"
goto :EOF
*/
new ActiveXObject("scripting.filesystemobject").createtextfile("tmp").write(String.fromCharCode(parseInt(WScript.arguments(0),16),String.fromCharCode(parseInt(WScript.arguments(1),16))))
/*
bat/jscript hybrid make script for Windows environments
a qkumba monstrosity from 2017-10-16
rem third-party tools required to build (must be in path)
rem https://sourceforge.net/projects/acme-crossass/
rem https://bitbucket.org/magli143/exomizer/wiki/Home
rem https://www.brutaldeluxe.fr/products/crossdevtools/cadius/
rem https://github.com/mach-kernel/cadius
*/
