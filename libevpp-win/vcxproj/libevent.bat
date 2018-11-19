set ROOT_DIR=%~dp0
set SRC_VER=libevent-2.1.8-stable
set TARGET_DIR=vcbuild
set TARGET_IN_DIR=include
cd ..
cd .\%TARGET_DIR%
MKDIR %TARGET_IN_DIR%
cd ..
XCOPY /S /Y .\%SRC_VER%\include\*  .\%TARGET_DIR%\%TARGET_IN_DIR%
XCOPY /S /Y .\%SRC_VER%\WIN32-Code\nmake\*  .\%TARGET_DIR%\%TARGET_IN_DIR%
DEL /F /A /Q  .\%TARGET_DIR%\%TARGET_IN_DIR%\*.am