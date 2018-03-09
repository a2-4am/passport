0</* :
@echo off
if "%1" equ "clean" (
echo y|1>nul rd build /s
goto :EOF
)
2>nul md build
cd src\mods
acme universalrwts.a
cd ..\..\build
exomize raw -q universalrwts.bin -o universalrwts.tmp
cscript /nologo //e:jscript %~f0 "b8" "00"
1>nul copy /b tmp+universalrwts.tmp universalrwts.pak
cd ..\src\mods
acme t00only.a
cd ..\..\build
exomize raw -q t00only.bin -o t00only.tmp
cscript /nologo //e:jscript %~f0 "20" "00"
1>nul copy /b tmp+t00only.tmp t00only.pak
cd ..\src
for /f "tokens=*" %%q in ('2^>^&1 acme passport.a') do set _make=%%q
acme -r ..\build\passport.lst -DRELBASE=$%_make:~-5,4% passport.a
set _make=
cd ..
1>nul copy res\work.po build\passport.po
java -jar bin\AppleCommander.jar -p build\passport.po "PASSPORT.SYSTEM" sys 0x2000 < build\PASSPORT.SYSTEM
goto :EOF
*/
new ActiveXObject("scripting.filesystemobject").createtextfile("tmp").write(String.fromCharCode(parseInt(WScript.arguments(0),16),String.fromCharCode(parseInt(WScript.arguments(1),16))))
/*
bat/jscript hybrid make script for Windows environments
a qkumba monstrosity from 2017-10-16
requires ACME, Exomizer, Apple Commander, Java
https://sourceforge.net/projects/acme-crossass/
https://sourceforge.net/projects/applecommander/
https://bitbucket.org/magli143/exomizer/wiki/Home
https://java.com/en/download/
requires ACME, Exomizer, Java to be in path
*/
