call "C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x86 /release
SET PATH=%PATH%;C:\Program Files\NASM;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1\Bin
SET INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\INCLUDE;C:\Program Files\Microsoft SDKs\Windows\v7.1\INCLUDE\gl;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1\Include
SET LIB=%LIB%;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1\Lib\

perl Configure no-comp no-shared VC-WIN32
nmake
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir C:\build
mkdir C:\build\lib
move libcrypto.lib C:\build\lib\
move libssl.lib C:\build\lib\
move include C:\build\include
