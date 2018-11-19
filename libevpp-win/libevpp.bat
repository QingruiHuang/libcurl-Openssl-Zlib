@echo off
cls
set THIS_EXE=%0
set ROOT_DIR=%~dp0
set SOURCE_EVPP=evpp-redfox1999
set SOURCE_GLOG=glog-0.3.5
set SOURCE_LIBEVENT=libevent-2.1.8-stable
set SOURCE_LIB_BUILD=vcsource
set BUILD_EVPP=evpp
set BUILD_GLOG=glog
set BUILD_LIBEVENT=libevent
set LIBEVPP_BUILD=libevpp-build
set LIBEVPP_SDK=libevpp-sdk
set SDK_INCLUDE=include
set SDK_LIB=lib
set SDK_PDB=pdb
set TODO=%1
echo ******************************************************** TODO=%TODO% ********************************************************
if "%TODO%"== "0" (
	call :Create-vcsource
) else (
	if "%TODO%"== "1" (
		call :sdk-libevpp-build-copy
	) else (
		if "%TODO%"== "2" (
			call :clear-libevpp-build
		) else (
			if "%TODO%"== "3" (
				call :clear-vcsource
			) else (
				call :usage
			)
		)
	)
)

GOTO:END


:usage
echo 		usage:
echo 			%THIS_EXE%   todo
echo 		                todo = 0; Create code at vcsource for libevpp.vcxproj
echo 		                todo = 1; copy sdk
echo 		                todo = 2; clear build dir
echo 		                todo = 3; clear vcsource
echo 		                todo = other; this message
@echo done for usage
GOTO:END

:Create-vcsource
IF EXIST %SOURCE_LIB_BUILD% (RD /S /Q %SOURCE_LIB_BUILD%)
MKDIR %SOURCE_LIB_BUILD%

:glog-Create
MKDIR %SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy %BUILD_GLOG% form .\%SOURCE_GLOG% to .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy .\%SOURCE_GLOG%\src\logging.cc
XCOPY /S /Y .\%SOURCE_GLOG%\src\logging.cc .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy .\%SOURCE_GLOG%\src\raw_logging.cc
XCOPY /S /Y .\%SOURCE_GLOG%\src\raw_logging.cc .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy .\%SOURCE_GLOG%\src\utilities.cc
XCOPY /S /Y .\%SOURCE_GLOG%\src\utilities.cc .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy .\%SOURCE_GLOG%\src\vlog_is_on.cc
XCOPY /S /Y .\%SOURCE_GLOG%\src\vlog_is_on.cc .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
echo copy .\%SOURCE_GLOG%\src\utilities.h
XCOPY /S /Y .\%SOURCE_GLOG%\src\utilities.h .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%
MKDIR %SOURCE_LIB_BUILD%\%BUILD_GLOG%\windows
XCOPY /S /Y .\%SOURCE_GLOG%\src\windows\* .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%\windows
RD /S /Q .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%\windows\preprocess.sh
MKDIR %SOURCE_LIB_BUILD%\%BUILD_GLOG%\base
XCOPY /S /Y .\%SOURCE_GLOG%\src\base\* .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%\base
XCOPY /S /Y .\vcxproj\%BUILD_GLOG%\src\*	.\%SOURCE_LIB_BUILD%\%BUILD_GLOG%

:libevent-Create
MKDIR %SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
echo copy %BUILD_LIBEVENT% form .\%SOURCE_LIBEVENT% to .\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\arc4random.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\buffer.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent_async.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent_filter.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent_pair.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent_ratelim.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\bufferevent_sock.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\buffer_iocp.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evdns.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\event.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\event_iocp.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\event_tagging.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evmap.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evport.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evrpc.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evthread.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evthread_win32.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evutil.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evutil_rand.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\evutil_time.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\http.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\listener.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\log.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\signal.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\strlcpy.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%
XCOPY /S /Y .\%SOURCE_LIBEVENT%\win32select.c	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%

XCOPY /S /Y .\%SOURCE_LIBEVENT%\*.h	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\*
XCOPY /S /Y .\vcxproj\%BUILD_LIBEVENT%\*	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\*
RD /S /Q 	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\sample
RD /S /Q 	.\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\test
DEL /F /A /Q .\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\evconfig-private.h

:evpp-Create
MKDIR %SOURCE_LIB_BUILD%\%BUILD_EVPP%
MKDIR %SOURCE_LIB_BUILD%\%BUILD_EVPP%\src
MKDIR %SOURCE_LIB_BUILD%\%BUILD_EVPP%\include
MKDIR %SOURCE_LIB_BUILD%\%BUILD_EVPP%\include\%BUILD_EVPP%
echo copy %BUILD_EVPP% form .\%SOURCE_EVPP% to .\%SOURCE_LIB_BUILD%\%BUILD_EVPP%
XCOPY /S /Y .\%SOURCE_EVPP%\evpp\*.h	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\include\%BUILD_EVPP%\*
XCOPY /S /Y .\%SOURCE_EVPP%\evpp\*.c	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\src\*
XCOPY /S /Y .\%SOURCE_EVPP%\evpp\*.cc	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\src\*

XCOPY /S /Y .\vcxproj\evpp\*.c	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\src\*
XCOPY /S /Y .\vcxproj\evpp\*.cc	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\src\*
XCOPY /S /Y .\vcxproj\evpp\*.h	.\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\include\%BUILD_EVPP%\*
@echo done for Create-vcsource
GOTO:END

:sdk-libevpp-build-copy
echo exe sdk copy
MKDIR %LIBEVPP_SDK%
cd .\%LIBEVPP_SDK%
IF EXIST %SDK_INCLUDE% (RD /S /Q %SDK_INCLUDE%)
MKDIR %SDK_INCLUDE%
MKDIR %SDK_INCLUDE%\%BUILD_GLOG%
MKDIR %SDK_INCLUDE%\%BUILD_EVPP%

IF EXIST %SDK_LIB% (RD /S /Q %SDK_LIB%)
MKDIR %SDK_LIB%
IF EXIST %SDK_PDB% (RD /S /Q %SDK_PDB%)
MKDIR %SDK_PDB%
cd %ROOT_DIR%

echo exe copy lib .............................
XCOPY /S /Y %LIBEVPP_BUILD%\*.lib %LIBEVPP_SDK%\%SDK_LIB%
XCOPY /S /Y %LIBEVPP_BUILD%\*.pdb %LIBEVPP_SDK%\%SDK_PDB%
echo exe copy pdb .............................
XCOPY /S /Y %LIBEVPP_BUILD%\*.idb %LIBEVPP_SDK%\%SDK_PDB%

echo exe copy include for %BUILD_GLOG% ..................................
XCOPY /S /Y .\%SOURCE_LIB_BUILD%\%BUILD_GLOG%\windows\%BUILD_GLOG%\*  .\%LIBEVPP_SDK%\%SDK_INCLUDE%\%BUILD_GLOG%

echo exe copy include for %BUILD_LIBEVENT% ..................................
XCOPY /S /Y .\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\include\*   .\%LIBEVPP_SDK%\%SDK_INCLUDE%
XCOPY /S /Y .\%SOURCE_LIB_BUILD%\%BUILD_LIBEVENT%\WIN32-Code\nmake\*  .\%LIBEVPP_SDK%\%SDK_INCLUDE%

echo exe copy include for %BUILD_EVPP% ..................................
XCOPY /S /Y .\%SOURCE_LIB_BUILD%\%BUILD_EVPP%\include\%BUILD_EVPP%\*.h  .\%LIBEVPP_SDK%\%SDK_INCLUDE%\%BUILD_EVPP%

@echo done for sdk copy
GOTO:END

:clear-libevpp-build
echo exe clear .\%LIBEVPP_BUILD% 
RD /S /Q .\%LIBEVPP_BUILD%
@echo done for clear-libevpp-build
GOTO:END


:clear-vcsource
echo exe clear .\%SOURCE_LIB_BUILD% 
RD /S /Q .\%SOURCE_LIB_BUILD%
@echo done for clear-vcsource
GOTO:END


:END
@echo end