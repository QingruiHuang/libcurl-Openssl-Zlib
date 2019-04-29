
@echo build zlib-1.2.8
cd /d %ZLIB_SRC%
nmake -f win32/Makefile.msc clean
if "%BUILD_MODE%"=="release" (
	nmake -f win32/Makefile.msc mode=release
) else (
	nmake -f win32/Makefile.msc mode=debug
)


@echo d | XCOPY /Y %ZLIB_SRC%\zlib.h %BUILD_OUT%\include
XCOPY /Y %ZLIB_SRC%\zconf.h %BUILD_OUT%\include
@echo d | XCOPY /Y %ZLIB_SRC%\zlib.lib %BUILD_OUT%\lib
RENAME %BUILD_OUT%\lib\zlib.lib zlib_a.lib
XCOPY /Y %ZLIB_SRC%\zlib.lib %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zdll.lib %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zdll.exp %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zlib1.dll %BUILD_OUT%\lib
XCOPY /Y %ZLIB_SRC%\zlib1.pdb %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\zlib.pdb %BUILD_OUT%\lib
MOVE /Y %BUILD_OUT%\zlib.idb %BUILD_OUT%\lib