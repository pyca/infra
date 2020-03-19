call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=x64
SET PATH=%PATH%;C:\Program Files\NASM

perl Configure no-comp no-shared VC-WIN64A
nmake
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir C:\build
mkdir C:\build\lib
move libcrypto.lib C:\build\lib\
move libssl.lib C:\build\lib\
move include C:\build\include
