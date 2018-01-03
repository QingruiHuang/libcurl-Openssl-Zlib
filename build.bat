cd .\zlib-1.2.8
%VC140_HOME%\vcvarsall.bat amd64
nmake -f win32/Makefile.msc


echo off & color 0A
@echo build openssl-1.0.2n
IF EXIST .\opensslSdk (RD /S /Q .\opensslSdk)
%VC140_HOME%\vcvarsall.bat amd64
set NASM=.\nasm-2.13.02
MKDIR .\opensslSdk
cd /d .\openssl-1.0.2n
perl  Configure VC-WIN64A no-asm --prefix=../opensslSdk64
::perl Configure debug-VC-WIN32 no-asm --prefix=../opensslSdk
ms\do_ms.bat
nmake -f ms\nt.mak

#拷贝zlib和opensslSdk相关静态库到.\curl-7.55.1\winbuild下
%VC140_HOME%\vcvarsall.bat amd64
IF EXIST .\Sdk (RD /S /Q .\Sdk)
MKDIR .\Sdk
cd .\curl-7.55.1\winbuild
nmake /f Makefile.vc mode=static MACHINE=amd64 VC=14 WITH_DEVEL=..\..\Sdk WITH_SSL=static WITH_ZLIB=static ENABLE_SSPI=no ENABLE_IPV6=yes