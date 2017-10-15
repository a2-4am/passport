0</* :
@echo off
2>nul md build
cd src\mods
acme universalrwts.a
exomize raw -q universalrwts.bin -o universalrwts.tmp
del universalrwts.bin
cscript /nologo //e:jscript %~f0 "b8" "00"
1>nul copy /b tmp+universalrwts.tmp universalrwts.pak
del universalrwts.tmp
acme t00only.a
exomize raw -q t00only.bin -o t00only.tmp
del t00only.bin
cscript /nologo //e:jscript %~f0 "20" "00"
1>nul copy /b tmp+t00only.tmp t00only.pak
del t00only.tmp
del tmp
cd ..
for /f "tokens=*" %%q in ('2^>^&1 acme passport.a') do set _make=%%q
acme -DRELBASE=$%_make:~-5,4% passport.a
set _make=
del mods\universalrwts.pak
del mods\t00only.pak
cd ..
goto :EOF
*/
new ActiveXObject("scripting.filesystemobject").createtextfile("tmp").write(String.fromCharCode(parseInt(WScript.arguments(0),16),String.fromCharCode(parseInt(WScript.arguments(1),16))))
