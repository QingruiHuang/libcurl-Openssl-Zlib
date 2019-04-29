
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
