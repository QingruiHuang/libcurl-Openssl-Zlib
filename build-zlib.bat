
@echo build zlib-1.2.8
cd /d %ZLIB_SRC%
nmake -f win32/Makefile.msc clean
if "%BUILD_MODE%"=="release" (
	nmake -f win32/Makefile.msc mode=release
) else (
	nmake -f win32/Makefile.msc mode=debug
)

@echo copy ZLIB sdk

XCOPY /Y %ZLIB_SRC%\zlib.h %BUILD_OUT%
XCOPY /Y %ZLIB_SRC%\zconf.h %BUILD_OUT%
XCOPY /Y %ZLIB_SRC%\zlib.lib %BUILD_OUT%
@echo d | XCOPY /Y %BUILD_OUT%\zlib.lib %BUILD_OUT%\lib
RENAME %BUILD_OUT%\zlib.lib zlib_a.lib
MOVE /Y %BUILD_OUT%\zlib_a.lib %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\*.h %BUILD_OUT%\include
XCOPY /Y %ZLIB_SRC%\zdll.lib %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zdll.exp %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zlib1.dll %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zlib1.pdb %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\zlib.pdb %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\zlib.idb %BUILD_OUT%\lib