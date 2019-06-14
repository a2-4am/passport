0</* :
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
2>..\build\out.txt %ACME% -DFORWARD_DECRUNCHING=1 passport.a
for /f "tokens=2,3 delims=)" %%q in ('find "RELBASE =" ..\build\out.txt') do set _make=%%q
2>..\build\out.txt %ACME% -r ..\build\passport.lst -DRELBASE=$%_make:~-4% -DFORWARD_DECRUNCHING=1 passport.a
for /f "tokens=2,3 delims=)" %%q in ('find "SaveProDOS=" ..\build\out.txt') do set _SaveProDOS=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "kForceLower=" ..\build\out.txt') do set _kForceLower=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "DiskIIArray=" ..\build\out.txt') do set _DiskIIArray=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "PrintByID=" ..\build\out.txt') do set _PrintByID=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "WaitForKey=" ..\build\out.txt') do set _WaitForKey=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "CleanExit=" ..\build\out.txt') do set _CleanExit=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "GetVolumeName=" ..\build\out.txt') do set _GetVolumeName=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "OnlineReturn=" ..\build\out.txt') do set _OnlineReturn=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "GetVolumeInfo=" ..\build\out.txt') do set _GetVolumeInfo=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "filetype=" ..\build\out.txt') do set _filetype=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "VolumeName=" ..\build\out.txt') do set _VolumeName=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "auxtype=" ..\build\out.txt') do set _auxtype=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "blocks=" ..\build\out.txt') do set _blocks=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "PREFSVER=" ..\build\out.txt') do set _PREFSVER=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "PREFSFILE=" ..\build\out.txt') do set _PREFSFILE=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "PREFSREADLEN=" ..\build\out.txt') do set _PREFSREADLEN=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "PREFSBUFFER=" ..\build\out.txt') do set _PREFSBUFFER=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "ValidatePrefs=" ..\build\out.txt') do set _ValidatePrefs=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "SavePrefs=" ..\build\out.txt') do set _SavePrefs=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "mliparam=" ..\build\out.txt') do set _mliparam=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "OpenFile=" ..\build\out.txt') do set _OpenFile=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "ReadFile=" ..\build\out.txt') do set _ReadFile=%%q
for /f "tokens=2,3 delims=)" %%q in ('find "CloseFile=" ..\build\out.txt') do set _CloseFile=%%q
cd ..\build
%EXOMIZER% raw -q -b passport.tmp -o passport.pak
cd ..\src
%ACME% -DSaveProDOS=$%_SaveProDOS:~-4% -DkForceLower=$%_kForceLower:~-4% -DDiskIIArray=$%_DiskIIArray:~-4% -DPrintByID=$%_PrintByID:~-4% -DWaitForKey=$%_WaitForKey:~-4% -DCleanExit=$%_CleanExit:~-4% -DGetVolumeName=$%_GetVolumeName:~-4% -DOnlineReturn=$%_OnlineReturn:~-4% -DGetVolumeInfo=$%_GetVolumeInfo:~-4% -Dfiletype=$%_filetype:~-4% -DVolumeName=$%_VolumeName:~-4% -Dauxtype=$%_auxtype:~-4% -Dblocks=$%_blocks:~-4% -DPREFSVER=$%_PREFSVER:~-4% -DPREFSFILE=$%_PREFSFILE:~-4% -DPREFSREADLEN=$%_PREFSREADLEN:~-1% -DPREFSBUFFER=$%_PREFSBUFFER:~-4% -DValidatePrefs=$%_ValidatePrefs:~-4% -DSavePrefs=$%_SavePrefs:~-4% -Dmliparam=$%_mliparam:~-4% -DOpenFile=$%_OpenFile:~-4% -DReadFile=$%_ReadFile:~-4% -DCloseFile=$%_CloseFile:~-4% -DFORWARD_DECRUNCHING=0 wrapper.a
cd ..
1>nul copy res\work.po build\passport.po
1>nul copy res\_FileInformation.txt build\
%CADIUS% ADDFILE "build\passport.po" "/PASSPORT/" "build\PASSPORT.SYSTEM"
cscript /nologo bin/po2do.js build\ build\
2>nul del "%BUILDDISK%.po"
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
