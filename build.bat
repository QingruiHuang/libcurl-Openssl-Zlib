@echo off & color 0A
@echo usage:
@echo 		build.bat   mode  platform  asm/no-asm
@echo 		                mode = 0,d; build debug
@echo 		                mode = 1,r; build release
@echo 		                platform = 0,32,86,x86; build x86
@echo 		                platform = 1,64,x64,amd64; build amd64
@echo 		                platform = other; build amd64_x86
@echo 		                asm     	build openssl with asm
@echo 		                no-asm     build openssl no-asm
@echo													

set ROOT_DIR=%~dp0
set BUILD_MODE=%1
set platform=%2
set WITH_ASM=%3
set OPENSSL_SRC=%~dp0openssl-1.0.2n
set ZLIB_SRC=%~dp0zlib-1.2.8
set JANSSON_ROOT=%~dp0jansson-2.12
set JANSSON_BUILD_DIR=%~dp0jansson-2.12-build
set NGHTTP2_SRC=%~dp0nghttp2
set NGHTTP2_BUILD_DIR=%~dp0nghttp2-build
set CURL_SRC=%~dp0curl-7.64.1
set LIBEVENT_SRC=%~dp0libevent-release-2.1.8-stable
set LIBEVENT_BUILD_DIR=%~dp0libevent-build
set CURL_BUILDS=%~dp0curl-7.64.1\builds
set CPR_ROOT=%~dp0cpr
set CPR_BUILD_DIR=%~dp0cpr-build
set BUILD_OUT=
@echo ROOT_DIR=%ROOT_DIR%

:BUILD_MODE
for %%a in (0 d debug) do (
if "%BUILD_MODE%"=="%%a" set BUILD_MODE=debug
)

for %%a in (1 r release) do (
if "%BUILD_MODE%"=="%%a" set BUILD_MODE=release
)

:ResetPlatform
for %%a in (0 32 86 x86) do (
if "%platform%"=="%%a" set platform=x86
)

for %%a in (1 64 x64 amd64) do (
if "%platform%"=="%%a" set platform=amd64
)

@echo %PATH%
set CURL_MACHINE=x86
set CURL_DEBUG=no
set CMAKE_BUILD_TYPE=Release
if "%BUILD_MODE%"=="release" (
	set PERL_VC=VC-WIN32
) else (
	set PERL_VC=debug-VC-WIN32
	set CURL_DEBUG=yes
	set CMAKE_BUILD_TYPE=Debug
)

if "%platform%"=="x86" (
@echo   
) else (
	if "%platform%"=="amd64" (
		set CURL_MACHINE=x64
		if "%BUILD_MODE%"=="release" (
			set PERL_VC=VC-WIN64A
		) else (
			set PERL_VC=debug-VC-WIN64A
		)
	) else (
		if "%PROCESSOR_ARCHITECTURE%"=="x86" set platform=x86
		if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set platform=amd64
		goto ResetPlatform
	)
)
@echo   WITH_ASM=%WITH_ASM%
if "%WITH_ASM%"=="asm" (
	if "%platform%"=="x86" (
		call %ROOT_DIR%asmwin32.bat
	) else (
		call %ROOT_DIR%asmwin64.bat
	)
) else (
	if "%WITH_ASM%"=="ASM" (
		set WITH_ASM=asm
		if "%platform%"=="x86" (
			call %ROOT_DIR%asmwin32.bat
		) else (
			call %ROOT_DIR%asmwin64.bat
		)
	) else (set WITH_ASM=no-asm)
)

set BUILD_OUT=%ROOT_DIR%libcurlSslZlibCpr_%platform%
rem echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(set BUILD_OUT=%BUILD_OUT%_asm)||(set BUILD_OUT=%BUILD_OUT%_no_asm)
if "%WITH_ASM%"=="asm" (
	set BUILD_OUT=%BUILD_OUT%_asm
) else (
	set BUILD_OUT=%BUILD_OUT%_no_asm
)
if "%BUILD_MODE%"=="release" (
	set BUILD_OUT=%BUILD_OUT%_release
) else (
	set BUILD_OUT=%BUILD_OUT%_debug
)
@echo BUILD_OUT=%BUILD_OUT%
IF EXIST %BUILD_OUT% (RD /S /Q %BUILD_OUT%)
MKDIR %BUILD_OUT% 
call %VC150_HOME%\vcvarsall.bat %platform%
@echo build openssl-1.0.2n %platform% %PERL_VC% %WITH_ASM%
cd /d %OPENSSL_SRC%
set SSL_DO_BAT=do_ms.bat
if "%platform%"=="x86" (
	if "%WITH_ASM%"=="asm" (
		set SSL_DO_BAT=do_nasm.bat
	)
) else (
	if "%WITH_ASM%"=="asm" (
		set SSL_DO_BAT=do_win64a.bat
	) else {
		set SSL_DO_BAT=do_win64i.bat
	}
)
set ASM=nasm
rem echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(perl  Configure %PERL_VC% --prefix=%BUILD_OUT%)||(perl  Configure %PERL_VC% no-asm --prefix=%BUILD_OUT%)
rem perl  Configure %PERL_VC% no-asm --prefix=%BUILD_OUT%
rem echo %PATH%|findstr /c:"nasm-2.13.02">nul 2>nul&&(call ms\do_nasm.bat)||(call ms\do_ms.bat)
if "%WITH_ASM%"=="asm" (
	perl  Configure %PERL_VC% --prefix=%BUILD_OUT%
) else (
	perl  Configure %PERL_VC% no-asm --prefix=%BUILD_OUT%
)


@echo call ms\%SSL_DO_BAT%
call ms\%SSL_DO_BAT%
nmake -f ms\nt.mak clean
nmake -f ms\nt.mak
nmake -f ms\nt.mak install

@echo build zlib-1.2.8
cd /d %ZLIB_SRC%
nmake -f win32/Makefile.msc clean
if "%BUILD_MODE%"=="release" (
	nmake -f win32/Makefile.msc mode=release
) else (
	nmake -f win32/Makefile.msc mode=debug
)


@echo build libevent-2.1.8-stable
cd /d %ROOT_DIR%
IF EXIST %LIBEVENT_BUILD_DIR% (RD /S /Q %LIBEVENT_BUILD_DIR%)
MKDIR %LIBEVENT_BUILD_DIR% 
cd /d %LIBEVENT_BUILD_DIR%
cmake -DVISUAL_STUDIO=2017 -DOPENSSL_DIR=%BUILD_OUT% -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%BUILD_OUT% -G "NMake Makefiles" %LIBEVENT_SRC%
nmake
nmake install


@echo copy ZLIB sdk

XCOPY /Y %ZLIB_SRC%\zlib.h %BUILD_OUT%
XCOPY /Y %ZLIB_SRC%\zconf.h %BUILD_OUT%
XCOPY /Y %ZLIB_SRC%\zlib.lib %BUILD_OUT%
@echo d | XCOPY /Y %BUILD_OUT%\zlib.lib %BUILD_OUT%\lib
RENAME %BUILD_OUT%\zlib.lib zlib_a.lib
MOVE /Y %BUILD_OUT%\zlib_a.lib %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\*.h %BUILD_OUT%\include

rem @echo build jansson-2.12
rem cd /d %ROOT_DIR%
rem IF EXIST %JANSSON_BUILD_DIR% (RD /S /Q %JANSSON_BUILD_DIR%)
rem MKDIR %JANSSON_BUILD_DIR% 
rem cd /d %JANSSON_BUILD_DIR%
rem cmake -DVISUAL_STUDIO=2017 -DUSE_SYSTEM_CURL=YES -DBUILD_CPR_TESTS=NO -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=%BUILD_OUT% -G "NMake Makefiles" %JANSSON_ROOT%
rem nmake
rem nmake install
rem @echo f | XCOPY /Y %BUILD_OUT%\lib\jansson_d.lib %BUILD_OUT%\lib\jansson.lib
rem @echo f | XCOPY /Y %BUILD_OUT%\lib\jansson_d.lib %BUILD_OUT%\lib\jansson-2.12.lib

@echo build nghttp2
set PATH=%PATH%;%BUILD_OUT%
cd /d %ROOT_DIR%
IF EXIST %NGHTTP2_BUILD_DIR% (RD /S /Q %NGHTTP2_BUILD_DIR%)
MKDIR %NGHTTP2_BUILD_DIR% 
cd /d %NGHTTP2_BUILD_DIR%
cmake -D VISUAL_STUDIO=2017 -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%BUILD_OUT% -G "NMake Makefiles" %NGHTTP2_SRC%
nmake
nmake install

@echo f | XCOPY /Y %BUILD_OUT%\lib\nghttp2.lib %BUILD_OUT%\lib\nghttp2_static.lib

set IS_DEBUG=yes
if "%BUILD_MODE%"=="release" (
	set IS_DEBUG=no
)
@echo build curl-7.64.1  RTLIBCFG=static mode=static MACHINE=%CURL_MACHINE% VC=15 WITH_DEVEL=%BUILD_OUT% WITH_SSL=static WITH_ZLIB=static ENABLE_SSPI=no ENABLE_IPV6=yes DEBUG=%IS_DEBUG% WITH_NGHTTP2=static
IF EXIST %CURL_BUILDS% (RD /S /Q %CURL_BUILDS%)
cd /d %CURL_SRC%\winbuild
nmake /f Makefile.vc RTLIBCFG=static mode=static MACHINE=%CURL_MACHINE% VC=15 WITH_DEVEL=%BUILD_OUT% WITH_SSL=static WITH_ZLIB=static ENABLE_SSPI=no ENABLE_IPV6=yes DEBUG=%IS_DEBUG% WITH_NGHTTP2=static
cd /d %CURL_BUILDS%
for /f "delims=" %%a in ('dir /ad/b') do (
cd %CURL_BUILDS%\%%a
IF EXIST .\bin (
XCOPY /Y %CURL_BUILDS%\%%a\bin %BUILD_OUT%\bin
XCOPY /Y %CURL_BUILDS%\%%a\lib %BUILD_OUT%\lib
if "%BUILD_MODE%"=="debug" (
	@echo f | XCOPY /Y %BUILD_OUT%\lib\libcurl_a_debug.lib  %BUILD_OUT%\lib\libcurl_a.lib
)
XCOPY /S /Y %CURL_BUILDS%\%%a\include\* %BUILD_OUT%\include
)
)


@echo f | XCOPY /Y %BUILD_OUT%\lib\libcurl_a.lib %BUILD_OUT%\lib\libcurl.lib

@echo build cpr
cd /d %ROOT_DIR%
IF EXIST %CPR_BUILD_DIR% (RD /S /Q %CPR_BUILD_DIR%)
MKDIR %CPR_BUILD_DIR% 
cd /d %CPR_BUILD_DIR%
cmake -DVISUAL_STUDIO=2017 -DCMAKE_USE_OPENSSL=YES -DUSE_SYSTEM_CURL=YES -DBUILD_CPR_TESTS=NO -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=%BUILD_OUT% -G "NMake Makefiles" %CPR_ROOT%
nmake
@echo copy cpr sdk
XCOPY /S /Y %CPR_ROOT%\include\*.h %BUILD_OUT%\include
XCOPY /S /Y %CPR_BUILD_DIR%\lib\*.lib %BUILD_OUT%\lib

cd %ROOT_DIR%
explorer %BUILD_OUT%