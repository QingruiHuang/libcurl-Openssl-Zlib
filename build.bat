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
set OPENSSL_SRC=%~dp0openssl-1.1.0j
set ZLIB_SRC=%~dp0zlib-1.2.8
set JANSSON_ROOT=%~dp0jansson-2.12
set JANSSON_BUILD_DIR=%~dp0jansson-2.12-build
set NGHTTP2_SRC=%~dp0nghttp2
set NGHTTP2_BUILD_DIR=%~dp0nghttp2-build
set CURL_SRC=%~dp0curl-7.64.1
set LIBEVENT_SRC=%~dp0libevent-release-2.1.8-stable
set LIBEVENT_BUILD_DIR=%~dp0libevent-build
set MBEDTLS_SRC=%~dp0mbedtls
set MBEDTLS_BUILD_DIR=%~dp0mbedtls-build
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
@echo   
) else (
	set CURL_DEBUG=yes
	set CMAKE_BUILD_TYPE=Debug
)

if "%platform%"=="x86" (
	set PERL_VC=VC-WIN32
) else (
	if "%platform%"=="amd64" (
		set CURL_MACHINE=x64
		set PERL_VC=VC-WIN64A
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

set BUILD_OUT=%ROOT_DIR%libcurlSslCpr_%platform%
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
rem IF EXIST %BUILD_OUT% (RD /S /Q %BUILD_OUT%)
MKDIR %BUILD_OUT% 
@echo call %VC150_HOME%\vcvarsall.bat %platform%
call %VC150_HOME%\vcvarsall.bat %platform%

@echo call build-zlib.bat to build zlib1.2.8
cd %ROOT_DIR%
rem call build-zlib.bat


@echo call build-mbedtls.bat to build mbedtls-2.16.1
cd %ROOT_DIR%
call build-mbedtls.bat

@echo call build-openssl.bat to build openssl1.1.0j
cd %ROOT_DIR%
call build-openssl.bat


@echo call build-libevent.bat to build libevent-release-2.1.8-stable
cd %ROOT_DIR%
rem call build-libevent.bat


@echo call build-nghttp2.bat to build nghttp2
cd %ROOT_DIR%
call build-nghttp2.bat

@echo call build-curl.bat to build curl-7.64.1
cd %ROOT_DIR%
call build-curl.bat

@echo call build-cpr.bat to build cpr
cd %ROOT_DIR%
call build-cpr.bat

cd %ROOT_DIR%
rem explorer %BUILD_OUT%