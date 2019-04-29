@echo build openssl-1.1.0j %platform% %PERL_VC% %WITH_ASM%
call %ROOT_DIR%envdmake.bat
cd /d %OPENSSL_SRC%

if "%BUILD_MODE%"=="release" (
	perl  Configure %PERL_VC% no-shared %WITH_ASM% --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
) else (
	perl  Configure %PERL_VC% no-shared %WITH_ASM% --debug --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
)


nmake clean
nmake
nmake install