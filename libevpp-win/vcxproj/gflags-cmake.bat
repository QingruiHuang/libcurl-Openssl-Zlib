set cmake_generator_name=%1
set ROOT_DIR=%~dp0
set SRC_VER=gflags-2.2.2
set SRC_CMAKE=gflags-cmake-build-%cmake_generator_name%
set TARGET_DIR=vcbuild
set TARGET_IN_DIR=include\gflags
RD /S /Q %SRC_CMAKE%
MKDIR %SRC_CMAKE%
cd .\%SRC_CMAKE%
cmake -G %cmake_generator_name% ../../%SRC_VER%
cd %ROOT_DIR%
cd ..
MKDIR .\%TARGET_DIR%
cd .\%TARGET_DIR%
MKDIR .\include
cd .\include
MKDIR .\gflags
cd %ROOT_DIR%
XCOPY /S /Y .\%SRC_CMAKE%\include\gflags\*  ..\%TARGET_DIR%\%TARGET_IN_DIR%