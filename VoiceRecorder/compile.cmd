REM @echo off
setlocal

set AREXE=%USERPROFILE%\AppData\Local\Arduino15\packages\AZ3166\tools\arm-none-eabi-gcc\5_4-2016q3\arm-none-eabi\bin\ar.exe
if not EXIST "%AREXE%" goto :notools
if "%ELL_ROOT%"=="" goto :noell

REM compile
%ELL_ROOT%\build\bin\release\compile -imap featurizer.ell -cfn Filter -cmn mfcc --bitcode -od . --fuseLinearOps True --header --blas false --optimize true --target custom --numBits 32 --cpu cortex-m4 --triple armv6m-gnueabi --features +vfp4,+d16,+soft-float
REM optimize
%ELL_ROOT%\external\LLVMNativeWindowsLibs.x64.3.9.1.2\build\native\tools\opt.exe featurizer.bc -o featurizer.opt.bc -O3
REM emit
%ELL_ROOT%\external\LLVMNativeWindowsLibs.x64.3.9.1.2\build\native\tools\llc.exe featurizer.opt.bc -o featurizer.S -O3 -filetype=asm -mtriple=armv6m-gnueabi -mcpu=cortex-m4 -relocation-model=pic -float-abi=soft -mattr=+vfp4,+d16

REM compile classifier
%ELL_ROOT%\build\bin\release\compile -imap classifier.ell -cfn Predict -cmn model --bitcode -od . --fuseLinearOps True --header --blas false --optimize true --target custom --numBits 32 --cpu cortex-m4 --triple armv6m-gnueabi --features +vfp4,+d16,+soft-float
REM optimize
%ELL_ROOT%\external\LLVMNativeWindowsLibs.x64.3.9.1.2\build\native\tools\opt.exe classifier.bc -o classifier.opt.bc -O3
REM emit
%ELL_ROOT%\external\LLVMNativeWindowsLibs.x64.3.9.1.2\build\native\tools\llc.exe classifier.opt.bc -o classifier.S -O3 -filetype=asm -mtriple=armv6m-gnueabi -mcpu=cortex-m4 -relocation-model=pic -float-abi=soft -mattr=+vfp4,+d16

goto :eof
:notools
echo Cannot find the AZ3166 assembler, please install Azure IOT Devkit SDK for VS Code
echo from: https://microsoft.github.io/azure-iot-developer-kit/docs/get-started/
goto :eof

:noell
echo Please set your ELL_ROOT variable
goto :eof