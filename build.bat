@echo off & color 0A
@echo usage:
@echo 		build.bat   platform  asm/no-asm
@echo 		                platform = 0,32,86,0x86; build x86
@echo 		                platform = 1,64,0x64,amd64; build amd64
@echo 		                platform = other; build amd64_x86
@echo 		                asm     	build openssl with asm
@echo 		                no-asm     build openssl no-asm
@echo													

set ROOT_DIR=%~dp0
set platform=%1
set WITH_ASM=%2
set OPENSSL_SRC=%~dp0openssl-1.0.2n
set ZLIB_SRC=%~dp0zlib-1.2.8
set CURL_SRC=%~dp0curl-7.55.1
set CURL_BUILDS=%~dp0curl-7.55.1\builds
set OPENSSL_BUILD=
@echo ROOT_DIR=%ROOT_DIR%
for %%a in (0 32 86 0x86) do (
if "%platform%"=="%%a" set platform=x86
)

for %%a in (1 64 0x64 amd64) do (
if "%platform%"=="%%a" set platform=amd64
)

for %%a in (ASM asm) do (
if "%WITH_ASM%"=="%%a" (call %ROOT_DIR%asm.bat)
)
@echo %PATH%
set CURL_MACHINE=x86
set PERL_VC=VC-WIN32
if "%platform%"=="x86" (
@echo   
) else (
	if "%platform%"=="amd64" (
	set PERL_VC=VC-WIN64A
	set CURL_MACHINE=x64
	) else (
		set platform=amd64_x86
	)
)

@echo platform=%platform%; PERL_VC=%PERL_VC%
set OPENSSL_BUILD=%ROOT_DIR%libcurlSslZlib_%platform%
echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(set OPENSSL_BUILD=%OPENSSL_BUILD%_asm)||(set OPENSSL_BUILD=%OPENSSL_BUILD%_no_asm)
@echo OPENSSL_BUILD=%OPENSSL_BUILD%
IF EXIST %OPENSSL_BUILD% (RD /S /Q %OPENSSL_BUILD%)
MKDIR %OPENSSL_BUILD% 
call %VC140_HOME%\vcvarsall.bat %platform%
@echo build openssl-1.0.2n
cd /d %OPENSSL_SRC%
echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(perl  Configure %PERL_VC% --prefix=%OPENSSL_BUILD%)||(perl  Configure %PERL_VC% no-asm --prefix=%OPENSSL_BUILD%)
rem perl  Configure %PERL_VC% no-asm --prefix=%OPENSSL_BUILD%
echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(call ms\do_nasm.bat)||(call ms\do_ms.bat)
nmake -f ms\nt.mak clean
nmake -f ms\nt.mak
nmake -f ms\nt.mak install

@echo build zlib-1.2.8
cd /d %ZLIB_SRC%
nmake -f win32/Makefile.msc clean
nmake -f win32/Makefile.msc

@echo build curl-7.55.1

IF EXIST %CURL_BUILDS% (RD /S /Q %CURL_BUILDS%)
XCOPY /Y %ZLIB_SRC%\zlib.h %OPENSSL_BUILD%
XCOPY /Y %ZLIB_SRC%\zconf.h %OPENSSL_BUILD%
XCOPY /Y %ZLIB_SRC%\zlib.lib %OPENSSL_BUILD%
RD /S /Q %OPENSSL_BUILD%\zlib_a.lib
RENAME %OPENSSL_BUILD%\zlib.lib zlib_a.lib
MOVE /Y %OPENSSL_BUILD%\*.h %OPENSSL_BUILD%\include
MOVE /Y %OPENSSL_BUILD%\zlib_a.lib %OPENSSL_BUILD%\lib

cd /d %CURL_SRC%\winbuild
nmake /f Makefile.vc mode=static MACHINE=%CURL_MACHINE% VC=14 WITH_DEVEL=%OPENSSL_BUILD% WITH_SSL=static WITH_ZLIB=static ENABLE_SSPI=no ENABLE_IPV6=yes
cd /d %CURL_BUILDS%
for /f "delims=" %%a in ('dir /ad/b') do (
cd %CURL_BUILDS%\%%a
IF EXIST .\bin (
XCOPY /Y %CURL_BUILDS%\%%a\bin %OPENSSL_BUILD%\bin
XCOPY /Y %CURL_BUILDS%\%%a\lib %OPENSSL_BUILD%\lib
XCOPY /S /Y %CURL_BUILDS%\%%a\include\* %OPENSSL_BUILD%\include
)
)
cd %ROOT_DIR%
explorer %OPENSSL_BUILD%