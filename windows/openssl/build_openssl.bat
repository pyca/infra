@echo on
SET BUILDARCH=%1

cd openssl-*

SET PATH=%PATH%;C:\Program Files\NASM
SET CL=/FS

REM Locate the Visual Studio install rather than hardcoding a version/edition,
REM so this keeps working as GitHub bumps the runner image (e.g. VS2022 -> VS2026).
REM The GitHub runner images put vswhere on PATH. If that ever stops being true,
REM it's installed by the VS Installer at a fixed location:
REM   "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`vswhere -latest -products * -property installationPath`) do set VSINSTALL=%%i
if not defined VSINSTALL (
    echo Could not locate a Visual Studio installation via vswhere
    exit /b 1
)

if "%BUILDARCH%" == "win32" (
    CALL "%VSINSTALL%\Common7\Tools\VsDevCmd.bat" -arch=x86
    CALL "%VSINSTALL%\VC\Auxiliary\Build\vcvarsall.bat" x86

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN32
) else if "%BUILDARCH%" == "win64" (
    CALL "%VSINSTALL%\Common7\Tools\VsDevCmd.bat" -arch=x64
    CALL "%VSINSTALL%\VC\Auxiliary\Build\vcvarsall.bat" x64

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN64A
) else if "%BUILDARCH%" == "arm64" (
    CALL "%VSINSTALL%\Common7\Tools\VsDevCmd.bat" -arch=arm64
    CALL "%VSINSTALL%\VC\Auxiliary\Build\vcvarsall.bat" arm64

    perl Configure %OPENSSL_BUILD_FLAGS_WINDOWS% VC-WIN64-ARM
)

jom
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir ..\build
mkdir ..\build\lib
move libcrypto.lib ..\build\lib\
move libssl.lib ..\build\lib\
move include ..\build\include
