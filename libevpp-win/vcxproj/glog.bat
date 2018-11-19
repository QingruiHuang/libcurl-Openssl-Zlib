set ROOT_DIR=%~dp0
set SRC_VER=glog-0.3.5
set TARGET_DIR=vcbuild
set TARGET_IN_DIR=include\glog
cd ..
cd .\%TARGET_DIR%
MKDIR .\include
cd .\include
MKDIR .\glog
cd %ROOT_DIR%..
XCOPY /S /Y .\%SRC_VER%\src\windows\glog\*  .\%TARGET_DIR%\%TARGET_IN_DIR%