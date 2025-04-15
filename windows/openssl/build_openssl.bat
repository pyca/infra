@echo on
SET BUILDARCH=%1

cd openssl-*

SET PATH=%PATH%;C:\Program Files\NASM
SET CL=/FS
if "%BUILDARCH%" == "win32" (
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=x86
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x86

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN32
) else if "%BUILDARCH%" == "win64" (
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=x64
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN64A
) else if "%BUILDARCH%" == "arm64" (
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=arm64
    CALL "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" arm64

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN64-CLANGASM-ARM
)

jom
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir ..\build
mkdir ..\build\lib
move libcrypto.lib ..\build\lib\
move libssl.lib ..\build\lib\
move include ..\build\include
