@echo build openssl-1.1.0j %platform% %PERL_VC% %WITH_ASM%
call %ROOT_DIR%envdmake.bat
cd /d %OPENSSL_SRC%

if "%BUILD_MODE%"=="release" (
	if "%WITH_ASM%"=="no-asm" (
		perl  Configure %PERL_VC% no-shared no-asm --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
	) else (
		perl  Configure %PERL_VC% no-shared --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
	)
) else (
	if "%WITH_ASM%"=="no-asm" (
		perl  Configure %PERL_VC% no-shared no-asm --debug --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
	) else (
		perl  Configure %PERL_VC% no-shared --debug --prefix=%BUILD_OUT%  -l%BUILD_OUT%  -l%BUILD_OUT%\include  -L%BUILD_OUT%   -L%BUILD_OUT%\lib  --openssldir=%BUILD_OUT% 
	)
)


nmake clean
nmake
nmake install