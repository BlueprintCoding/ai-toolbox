@echo off
title WinPE Setup

REM ANSI Escape Code for Colors
set "reset=[0m"

REM Strong Foreground Colors
set "white_fg_strong=[90m"
set "red_fg_strong=[91m"
set "green_fg_strong=[92m"
set "yellow_fg_strong=[93m"
set "blue_fg_strong=[94m"
set "magenta_fg_strong=[95m"
set "cyan_fg_strong=[96m"

REM Normal Background Colors
set "red_bg=[41m"
set "blue_bg=[44m"

REM Define variables for logging
set "log_path=%~dp0logs.log"
set "log_invalidinput=[ERROR] Invalid input. Please enter a valid number."
set "echo_invalidinput=%red_fg_strong%[ERROR] Invalid input. Please enter a valid number.%reset%"


REM home Frontend
:home
title WinPE Setup [HOME]
cls
echo %blue_fg_strong%/ Home %reset%
echo -------------------------------------
echo What would you like to do?
echo 1. Install Windows 11
echo 2. Install Windows 10
echo 3. Toolbox
echo 0. Exit


set "choice="
set /p "choice=Choose Your Destiny (default is 1): "

REM Default to choice 1 if no input is provided
REM Disable REM below to enable default choise
if not defined choice set "choice=1"

REM home - Backend
if "%choice%"=="1" (
    call :install_windows11
) else if "%choice%"=="2" (
    call :install_windows10
) else if "%choice%"=="3" (
    call :toolbox
) else if "%choice%"=="0" (
    exit
) else (
    echo %red_bg%[%time%]%reset% %echo_invalidinput%
    pause
    goto :home
)


:install_windows11
title WinPE Setup [INSTALL WINDOWS 11]
cls
echo %blue_fg_strong%/ Home / Install Windows 11%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Starting installation for Windows 11...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Checking and bypassing specific setup checks...
for %%s in (sCPU sSecureBoot sTPM) do reg add HKLM\SYSTEM\Setup\LabConfig /f /v Bypass%%sCheck /d 1 /t reg_dword

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Initializing Windows PE environment...
wpeinit

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Connecting to network drive (Z:)...
net use Z: \\YOUR_NETBOOTXYZ-SAMBA_IP\netboot\assets\windows\11 /user:netboot netboot123

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Starting setup with unattended XML...
z:\setup.exe /unattend:x:\unattend.xml
goto :home

:install_windows10
title WinPE Setup [INSTALL WINDOWS 10]
cls
echo %blue_fg_strong%/ Home / Install Windows 10%reset%
echo ---------------------------------------------------------------
echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Starting installation for Windows 10...

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Initializing Windows PE environment...
wpeinit

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Connecting to network drive (Z:)...
net use Z: \\YOUR_NETBOOTXYZ-SAMBA_IP\netboot\assets\windows\10 /user:netboot netboot123

echo %blue_bg%[%time%]%reset% %blue_fg_strong%[INFO]%reset% Starting setup with unattended XML...
z:\setup.exe /unattend:x:\unattend.xml
goto :home


REM Toolbox - Frontend
:toolbox
title WinPE Setup [TOOLBOX]
cls
echo %blue_fg_strong%/ Home / Toolbox%reset%
echo -------------------------------------
echo What would you like to do?
echo 1. Run cmd
echo 2. Run powershell
echo 3. Run regedit
echo 4. Run notepad
echo 5. Run task manager
echo 6. Run network check
echo 0. Back to Home

set /p toolbox_choice=Choose Your Destiny: 

REM Toolbox - Backend
if "%toolbox_choice%"=="1" (
    call :run_cmd
) else if "%toolbox_choice%"=="2" (
    goto :run_powershell
) else if "%toolbox_choice%"=="3" (
    goto :run_regedit
) else if "%toolbox_choice%"=="4" (
    goto :run_notepad
) else if "%toolbox_choice%"=="5" (
    goto :run_taskmgr
) else if "%toolbox_choice%"=="6" (
    goto :run_networkcheck
) else if "%toolbox_choice%"=="0" (
    goto :home
) else (
    echo %red_bg%[%time%]%reset% %red_fg_strong%[ERROR] Invalid number. Please enter a valid number.%reset%
    pause
    goto :toolbox
)


:run_cmd
start cmd
goto :toolbox

:run_powershell
start powershell
goto :toolbox

:run_regedit
start regedit
goto :toolbox

:run_notepad
start notepad
goto :toolbox

:run_taskmgr
start taskmgr
goto :toolbox

:run_networkcheck
REM Retrieve external IP address
for /f "tokens=1* delims=: " %%A in (
  'nslookup myip.opendns.com. resolver1.opendns.com 2^>NUL^|find "Address:"'
) Do set ExtIP=%%B

REM Display results
echo External IP is: %cyan_fg_strong%%ExtIP%%reset%
pause
goto :toolbox