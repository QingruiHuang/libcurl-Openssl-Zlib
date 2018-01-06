@echo off & color 0A
cls
set ROOT_DIR=%~dp0
set LAME_TAR_GZ=%~dp0lame-3.99.5.tar.gz
set LAME_TAR=%~dp0lame-3.99.5.tar
set LAME_SRC=%~dp0lame-3.99.5
set LAME_BUILD=%~dp0lame-3.99.5-build
set NASM_PATH=%~dp0nasm-2.13.02
set PATH=%PATH%;%NASM_PATH%

IF EXIST %LAME_SRC% (RD /S /Q %LAME_SRC%)
IF EXIST %LAME_TAR% (DEL %LAME_TAR%)

7z x %LAME_TAR_GZ%
7z x %LAME_TAR%
DEL  %LAME_TAR%
XCOPY /Y %ROOT_DIR%Makefile.lame-3.99.5.MSVC %LAME_SRC%
cd /d %LAME_SRC%
call %VC140_HOME%\vcvarsall.bat x86
nmake -f Makefile.lame-3.99.5.MSVC
cd /d %ROOT_DIR%
IF EXIST %LAME_BUILD% (RD /S /Q %LAME_BUILD%)
MKDIR %LAME_BUILD%
MKDIR %LAME_BUILD%\bin
MKDIR %LAME_BUILD%\include
MKDIR %LAME_BUILD%\lib
XCOPY /Y %LAME_SRC%\include\lame.h %LAME_BUILD%\include
XCOPY /Y %LAME_SRC%\output\*.exe %LAME_BUILD%\bin
XCOPY /Y %LAME_SRC%\output\*.lib %LAME_BUILD%\lib
explorer %LAME_BUILD%