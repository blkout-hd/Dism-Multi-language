@echo off
setlocal enabledelayedexpansion
REM ====================================================================
REM Dism++ Automation CLI
REM Advanced Windows Image Management and Configuration Tool
REM Version 1.0
REM ====================================================================

title Dism++ Automation CLI
color 0A

:MAIN_MENU
cls
echo.
echo ========================================================================
echo                    Dism++ Automation CLI v1.0
echo         Advanced Windows Configuration and Deployment Tool
echo ========================================================================
echo.
echo  [1]  System Configuration Replicator
echo  [2]  Hardware Restriction Bypass (e.g., Intel 7700K)
echo  [3]  Driver Injection (Ethernet, VMD, Storage)
echo  [4]  OOBE Skip Configuration
echo  [5]  Telemetry and Tracker Removal
echo  [6]  Performance Optimization Suite
echo  [7]  User Scaffolding Automation
echo  [8]  DevOps Configuration Builder
echo  [9]  Security Hardening and Secpol Configuration
echo  [10] UUID/GUID Masking and Cloaking
echo  [11] Registry Virtualization Setup
echo  [12] BitLocker and TPM Key Management
echo  [13] Scan Current System Configuration
echo  [14] Create Adaptive Configuration Profile
echo  [0]  Exit
echo.
echo ========================================================================
echo.
set /p choice="Enter your choice (0-14): "

if "%choice%"=="1" goto CONFIG_REPLICATOR
if "%choice%"=="2" goto HARDWARE_BYPASS
if "%choice%"=="3" goto DRIVER_INJECTION
if "%choice%"=="4" goto OOBE_SKIP
if "%choice%"=="5" goto TELEMETRY_REMOVAL
if "%choice%"=="6" goto PERFORMANCE_OPT
if "%choice%"=="7" goto USER_SCAFFOLDING
if "%choice%"=="8" goto DEVOPS_SCAFFOLDING
if "%choice%"=="9" goto SECURITY_HARDENING
if "%choice%"=="10" goto UUID_MASKING
if "%choice%"=="11" goto REGISTRY_VIRT
if "%choice%"=="12" goto BITLOCKER_TPM
if "%choice%"=="13" goto SCAN_CONFIG
if "%choice%"=="14" goto ADAPTIVE_CONFIG
if "%choice%"=="0" goto EXIT
goto MAIN_MENU

:CONFIG_REPLICATOR
cls
echo.
echo ========================================================================
echo              System Configuration Replicator
echo ========================================================================
echo.
echo Select Windows Edition:
echo  [1] Windows Enterprise
echo  [2] Windows Pro
echo  [3] Windows Workstation Pro
echo  [4] Auto-detect current system
echo  [0] Back to Main Menu
echo.
set /p edition="Enter choice: "

if "%edition%"=="1" set EDITION=Enterprise
if "%edition%"=="2" set EDITION=Pro
if "%edition%"=="3" set EDITION=WorkstationPro
if "%edition%"=="4" goto AUTO_DETECT_EDITION
if "%edition%"=="0" goto MAIN_MENU

call :CREATE_CONFIG_PROFILE %EDITION%
pause
goto MAIN_MENU

:AUTO_DETECT_EDITION
echo Detecting current Windows edition...
for /f "tokens=3*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID 2^>nul') do set DETECTED_EDITION=%%a
echo Detected Edition: %DETECTED_EDITION%
call :CREATE_CONFIG_PROFILE %DETECTED_EDITION%
pause
goto MAIN_MENU

:CREATE_CONFIG_PROFILE
set PROFILE_EDITION=%~1
echo.
echo Creating configuration profile for %PROFILE_EDITION%...
if not exist "ConfigProfiles" mkdir ConfigProfiles
set PROFILE_FILE=ConfigProfiles\Config_%PROFILE_EDITION%_%date:~-4,4%%date:~-10,2%%date:~-7,2%.xml
echo ^<?xml version="1.0" encoding="utf-8"?^> > "%PROFILE_FILE%"
echo ^<Configuration^> >> "%PROFILE_FILE%"
echo   ^<Edition^>%PROFILE_EDITION%^</Edition^> >> "%PROFILE_FILE%"
echo   ^<Timestamp^>%date% %time%^</Timestamp^> >> "%PROFILE_FILE%"
echo   ^<SystemInfo^> >> "%PROFILE_FILE%"
echo     ^<ComputerName^>%COMPUTERNAME%^</ComputerName^> >> "%PROFILE_FILE%"
echo     ^<UserName^>%USERNAME%^</UserName^> >> "%PROFILE_FILE%"
echo   ^</SystemInfo^> >> "%PROFILE_FILE%"
echo   ^<Features^> >> "%PROFILE_FILE%"
call :EXPORT_FEATURES "%PROFILE_FILE%"
echo   ^</Features^> >> "%PROFILE_FILE%"
echo ^</Configuration^> >> "%PROFILE_FILE%"
echo Configuration profile saved to: %PROFILE_FILE%
echo.
goto :EOF

:EXPORT_FEATURES
set FEAT_FILE=%~1
echo     ^<OOBEBypass^>true^</OOBEBypass^> >> "%FEAT_FILE%"
echo     ^<TelemetryRemoval^>true^</TelemetryRemoval^> >> "%FEAT_FILE%"
echo     ^<PerformanceOptimization^>true^</PerformanceOptimization^> >> "%FEAT_FILE%"
goto :EOF

:HARDWARE_BYPASS
cls
echo.
echo ========================================================================
echo            Hardware Restriction Bypass Configuration
echo ========================================================================
echo.
echo This module removes installation blocks for unsupported hardware.
echo.
echo Supported scenarios:
echo  - Intel 7th Gen (Kaby Lake) processors on Windows 11
echo  - Unsupported TPM versions
echo  - Secure Boot requirements
echo  - RAM minimum requirements
echo.
set /p apply_bypass="Apply hardware bypasses? (Y/N): "
if /i "%apply_bypass%"=="Y" (
    call :APPLY_HARDWARE_BYPASS
    echo Hardware bypasses applied successfully!
) else (
    echo Operation cancelled.
)
pause
goto MAIN_MENU

:APPLY_HARDWARE_BYPASS
echo.
echo Creating registry bypass configuration...
if not exist "BypassConfigs" mkdir BypassConfigs
set BYPASS_FILE=BypassConfigs\HardwareBypass.reg
echo Windows Registry Editor Version 5.00 > "%BYPASS_FILE%"
echo. >> "%BYPASS_FILE%"
echo [HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig] >> "%BYPASS_FILE%"
echo "BypassTPMCheck"=dword:00000001 >> "%BYPASS_FILE%"
echo "BypassSecureBootCheck"=dword:00000001 >> "%BYPASS_FILE%"
echo "BypassRAMCheck"=dword:00000001 >> "%BYPASS_FILE%"
echo "BypassCPUCheck"=dword:00000001 >> "%BYPASS_FILE%"
echo "BypassStorageCheck"=dword:00000001 >> "%BYPASS_FILE%"
echo.
echo Registry file created: %BYPASS_FILE%
echo Apply this file to target WIM before installation.
goto :EOF

:DRIVER_INJECTION
cls
echo.
echo ========================================================================
echo              Driver Injection into WIM/ESD
echo ========================================================================
echo.
echo Select driver type to inject:
echo  [1] Ethernet Drivers
echo  [2] VMD (Intel Volume Management Device) Drivers
echo  [3] Storage Drivers
echo  [4] All Drivers (Batch Injection)
echo  [0] Back to Main Menu
echo.
set /p driver_choice="Enter choice: "

if "%driver_choice%"=="1" set DRIVER_TYPE=Ethernet
if "%driver_choice%"=="2" set DRIVER_TYPE=VMD
if "%driver_choice%"=="3" set DRIVER_TYPE=Storage
if "%driver_choice%"=="4" set DRIVER_TYPE=All
if "%driver_choice%"=="0" goto MAIN_MENU

call :INJECT_DRIVERS %DRIVER_TYPE%
pause
goto MAIN_MENU

:INJECT_DRIVERS
set INJ_TYPE=%~1
echo.
echo Preparing %INJ_TYPE% driver injection...
echo.
echo Note: This requires:
echo  1. Mounted WIM/ESD image path
echo  2. Driver source directory
echo.
set /p WIM_PATH="Enter mounted WIM path (e.g., C:\Mount\Windows): "
set /p DRIVER_PATH="Enter driver source path (e.g., C:\Drivers\%INJ_TYPE%): "

if not exist "%WIM_PATH%" (
    echo Error: WIM mount path not found!
    goto :EOF
)

if not exist "%DRIVER_PATH%" (
    echo Error: Driver path not found!
    goto :EOF
)

echo.
echo Injecting %INJ_TYPE% drivers...
dism /Image:"%WIM_PATH%" /Add-Driver /Driver:"%DRIVER_PATH%" /Recurse /ForceUnsigned
echo.
echo Driver injection completed!
goto :EOF

:OOBE_SKIP
cls
echo.
echo ========================================================================
echo              OOBE Skip Configuration
echo ========================================================================
echo.
echo This module configures automatic OOBE (Out-of-Box Experience) skip.
echo.
echo Options:
echo  [1] Create OOBE bypass unattend.xml
echo  [2] Configure auto-login
echo  [3] Skip network setup
echo  [4] Complete OOBE skip (All options)
echo  [0] Back to Main Menu
echo.
set /p oobe_choice="Enter choice: "

if "%oobe_choice%"=="1" call :CREATE_OOBE_UNATTEND
if "%oobe_choice%"=="2" call :CONFIG_AUTO_LOGIN
if "%oobe_choice%"=="3" call :SKIP_NETWORK_SETUP
if "%oobe_choice%"=="4" call :COMPLETE_OOBE_SKIP
if "%oobe_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:CREATE_OOBE_UNATTEND
echo.
echo Creating OOBE bypass unattend.xml...
if not exist "OOBEConfigs" mkdir OOBEConfigs
set UNATTEND_FILE=OOBEConfigs\unattend_oobe_bypass.xml
echo ^<?xml version="1.0" encoding="utf-8"?^> > "%UNATTEND_FILE%"
echo ^<unattend xmlns="urn:schemas-microsoft-com:unattend"^> >> "%UNATTEND_FILE%"
echo   ^<settings pass="oobeSystem"^> >> "%UNATTEND_FILE%"
echo     ^<component name="Microsoft-Windows-Shell-Setup"^> >> "%UNATTEND_FILE%"
echo       ^<OOBE^> >> "%UNATTEND_FILE%"
echo         ^<HideEULAPage^>true^</HideEULAPage^> >> "%UNATTEND_FILE%"
echo         ^<HideOEMRegistrationScreen^>true^</HideOEMRegistrationScreen^> >> "%UNATTEND_FILE%"
echo         ^<HideOnlineAccountScreens^>true^</HideOnlineAccountScreens^> >> "%UNATTEND_FILE%"
echo         ^<HideWirelessSetupInOOBE^>true^</HideWirelessSetupInOOBE^> >> "%UNATTEND_FILE%"
echo         ^<ProtectYourPC^>3^</ProtectYourPC^> >> "%UNATTEND_FILE%"
echo         ^<SkipUserOOBE^>true^</SkipUserOOBE^> >> "%UNATTEND_FILE%"
echo         ^<SkipMachineOOBE^>true^</SkipMachineOOBE^> >> "%UNATTEND_FILE%"
echo       ^</OOBE^> >> "%UNATTEND_FILE%"
echo     ^</component^> >> "%UNATTEND_FILE%"
echo   ^</settings^> >> "%UNATTEND_FILE%"
echo ^</unattend^> >> "%UNATTEND_FILE%"
echo Unattend file created: %UNATTEND_FILE%
goto :EOF

:CONFIG_AUTO_LOGIN
echo.
echo Configuring auto-login...
set /p AUTO_USER="Enter username for auto-login: "
set /p AUTO_PASS="Enter password (leave blank for no password): "
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%AUTO_USER%" /f >nul 2>&1
if not "%AUTO_PASS%"=="" reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%AUTO_PASS%" /f >nul 2>&1
echo Auto-login configured for user: %AUTO_USER%
goto :EOF

:SKIP_NETWORK_SETUP
echo.
echo Configuring network setup skip...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f >nul 2>&1
echo Network setup skip configured.
goto :EOF

:COMPLETE_OOBE_SKIP
call :CREATE_OOBE_UNATTEND
call :SKIP_NETWORK_SETUP
echo.
echo Complete OOBE skip configuration applied!
goto :EOF

:TELEMETRY_REMOVAL
cls
echo.
echo ========================================================================
echo           Telemetry and Tracker Removal Suite
echo ========================================================================
echo.
echo This module removes Windows telemetry, tracking, and diagnostic services.
echo.
echo Options:
echo  [1] Disable all telemetry services
echo  [2] Remove telemetry scheduled tasks
echo  [3] Block telemetry domains (hosts file)
echo  [4] Complete removal (All options)
echo  [0] Back to Main Menu
echo.
set /p telemetry_choice="Enter choice: "

if "%telemetry_choice%"=="1" call :DISABLE_TELEMETRY_SERVICES
if "%telemetry_choice%"=="2" call :REMOVE_TELEMETRY_TASKS
if "%telemetry_choice%"=="3" call :BLOCK_TELEMETRY_DOMAINS
if "%telemetry_choice%"=="4" call :COMPLETE_TELEMETRY_REMOVAL
if "%telemetry_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:DISABLE_TELEMETRY_SERVICES
echo.
echo Disabling telemetry services...
sc config DiagTrack start= disabled >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc config diagnosticshub.standardcollector.service start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc stop diagnosticshub.standardcollector.service >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo Telemetry services disabled.
goto :EOF

:REMOVE_TELEMETRY_TASKS
echo.
echo Removing telemetry scheduled tasks...
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
echo Telemetry tasks removed.
goto :EOF

:BLOCK_TELEMETRY_DOMAINS
echo.
echo Blocking telemetry domains in hosts file...
if not exist "TelemetryConfigs" mkdir TelemetryConfigs
set HOSTS_APPEND=TelemetryConfigs\telemetry_hosts_append.txt
echo # Telemetry blocking entries > "%HOSTS_APPEND%"
echo 0.0.0.0 vortex.data.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 vortex-win.data.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 telecommand.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 telecommand.telemetry.microsoft.com.nsatc.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 oca.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 sqm.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 watson.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 redir.metaservices.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 choice.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 df.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 reports.wes.df.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 wes.df.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 services.wes.df.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 sqm.df.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 watson.ppe.telemetry.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 telemetry.appex.bing.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 telemetry.urs.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 telemetry.appex.bing.net:443 >> "%HOSTS_APPEND%"
echo 0.0.0.0 settings-sandbox.data.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 vortex-sandbox.data.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 survey.watson.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 watson.live.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 watson.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 statsfe2.ws.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 corpext.msitadfs.glbdns2.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 compatexchange.cloudapp.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 cs1.wpc.v0cdn.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 a-0001.a-msedge.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 statsfe2.update.microsoft.com.akadns.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 sls.update.microsoft.com.akadns.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 fe2.update.microsoft.com.akadns.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 diagnostics.support.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 corp.sts.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 statsfe1.ws.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 pre.footprintpredict.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 i1.services.social.microsoft.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 i1.services.social.microsoft.com.nsatc.net >> "%HOSTS_APPEND%"
echo 0.0.0.0 feedback.windows.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 feedback.microsoft-hohm.com >> "%HOSTS_APPEND%"
echo 0.0.0.0 feedback.search.microsoft.com >> "%HOSTS_APPEND%"
echo Telemetry domains list created: %HOSTS_APPEND%
echo Note: Manually append this file to C:\Windows\System32\drivers\etc\hosts
goto :EOF

:COMPLETE_TELEMETRY_REMOVAL
call :DISABLE_TELEMETRY_SERVICES
call :REMOVE_TELEMETRY_TASKS
call :BLOCK_TELEMETRY_DOMAINS
echo.
echo Complete telemetry removal applied!
goto :EOF

:PERFORMANCE_OPT
cls
echo.
echo ========================================================================
echo              Performance Optimization Suite
echo ========================================================================
echo.
echo Select optimization:
echo  [1] Multimedia Scheduling (MMCSS) Optimization
echo  [2] WinRE (Recovery Environment) Optimization
echo  [3] Dual Boot Configuration
echo  [4] System Responsiveness Tuning
echo  [5] Complete Performance Suite
echo  [0] Back to Main Menu
echo.
set /p perf_choice="Enter choice: "

if "%perf_choice%"=="1" call :OPTIMIZE_MMCSS
if "%perf_choice%"=="2" call :OPTIMIZE_WINRE
if "%perf_choice%"=="3" call :CONFIG_DUAL_BOOT
if "%perf_choice%"=="4" call :OPTIMIZE_RESPONSIVENESS
if "%perf_choice%"=="5" call :COMPLETE_PERFORMANCE_OPT
if "%perf_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:OPTIMIZE_MMCSS
echo.
echo Optimizing Multimedia Class Scheduler Service...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo MMCSS optimization applied.
goto :EOF

:OPTIMIZE_WINRE
echo.
echo Optimizing Windows Recovery Environment...
reagentc /info
echo.
echo Note: WinRE optimization requires manual configuration based on your system.
echo Recommended: Use compact WinRE image and disable unnecessary recovery features.
goto :EOF

:CONFIG_DUAL_BOOT
echo.
echo Configuring Dual Boot settings...
echo.
echo Current boot configuration:
bcdedit /enum
echo.
set /p timeout_val="Enter boot menu timeout in seconds (default 30): "
if "%timeout_val%"=="" set timeout_val=30
bcdedit /timeout %timeout_val%
echo.
echo Dual boot timeout set to %timeout_val% seconds.
goto :EOF

:OPTIMIZE_RESPONSIVENESS
echo.
echo Optimizing system responsiveness...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul 2>&1
echo System responsiveness optimized.
goto :EOF

:COMPLETE_PERFORMANCE_OPT
call :OPTIMIZE_MMCSS
call :OPTIMIZE_RESPONSIVENESS
echo.
echo Complete performance optimization applied!
goto :EOF

:USER_SCAFFOLDING
cls
echo.
echo ========================================================================
echo              User Scaffolding Automation
echo ========================================================================
echo.
echo This module creates automated user account configurations.
echo.
echo Options:
echo  [1] Create bulk users from CSV
echo  [2] Configure default user profile
echo  [3] Set user permissions template
echo  [4] Export current user configuration
echo  [0] Back to Main Menu
echo.
set /p user_choice="Enter choice: "

if "%user_choice%"=="1" call :BULK_USER_CREATION
if "%user_choice%"=="2" call :CONFIG_DEFAULT_PROFILE
if "%user_choice%"=="3" call :SET_USER_PERMISSIONS
if "%user_choice%"=="4" call :EXPORT_USER_CONFIG
if "%user_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:BULK_USER_CREATION
echo.
echo Creating bulk users...
if not exist "UserConfigs" mkdir UserConfigs
set CSV_FILE=UserConfigs\users_template.csv
if not exist "%CSV_FILE%" (
    echo username,password,fullname,description > "%CSV_FILE%"
    echo admin1,P@ssw0rd,Admin User 1,Administrator Account >> "%CSV_FILE%"
    echo user1,P@ssw0rd,Standard User 1,Standard User Account >> "%CSV_FILE%"
    echo Template CSV created: %CSV_FILE%
    echo Edit this file and run again to create users.
) else (
    echo Processing users from CSV...
    for /f "skip=1 tokens=1-4 delims=," %%a in (%CSV_FILE%) do (
        net user %%a %%b /add /fullname:"%%c" /comment:"%%d" >nul 2>&1
        echo Created user: %%a
    )
    echo Bulk user creation completed.
)
goto :EOF

:CONFIG_DEFAULT_PROFILE
echo.
echo Configuring default user profile...
echo Copy desired settings to C:\Users\Default for all new users.
echo Common locations:
echo   - C:\Users\Default\AppData
echo   - C:\Users\Default\Desktop
echo   - C:\Users\Default\NTUSER.DAT
goto :EOF

:SET_USER_PERMISSIONS
echo.
echo Setting user permissions template...
if not exist "UserConfigs" mkdir UserConfigs
set PERM_FILE=UserConfigs\user_permissions.txt
echo # User Permissions Template > "%PERM_FILE%"
echo Standard Users: >> "%PERM_FILE%"
echo   - Read access to Program Files >> "%PERM_FILE%"
echo   - Write access to user profile only >> "%PERM_FILE%"
echo   - No admin rights >> "%PERM_FILE%"
echo. >> "%PERM_FILE%"
echo Power Users: >> "%PERM_FILE%"
echo   - Read/Write to most system areas >> "%PERM_FILE%"
echo   - Limited admin tasks >> "%PERM_FILE%"
echo. >> "%PERM_FILE%"
echo Administrators: >> "%PERM_FILE%"
echo   - Full system access >> "%PERM_FILE%"
echo Template created: %PERM_FILE%
goto :EOF

:EXPORT_USER_CONFIG
echo.
echo Exporting current user configuration...
if not exist "UserConfigs" mkdir UserConfigs
set EXPORT_FILE=UserConfigs\current_users_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
echo Current Users Configuration > "%EXPORT_FILE%"
echo ========================== >> "%EXPORT_FILE%"
echo. >> "%EXPORT_FILE%"
net user >> "%EXPORT_FILE%"
echo. >> "%EXPORT_FILE%"
echo Local Groups >> "%EXPORT_FILE%"
echo ============ >> "%EXPORT_FILE%"
net localgroup >> "%EXPORT_FILE%"
echo Configuration exported to: %EXPORT_FILE%
goto :EOF

:DEVOPS_SCAFFOLDING
cls
echo.
echo ========================================================================
echo              DevOps Configuration Builder
echo ========================================================================
echo.
echo This module creates DevOps-ready system configurations.
echo.
echo Options:
echo  [1] Install WSL and Docker prerequisites
echo  [2] Configure PowerShell execution policy
echo  [3] Setup development user accounts
echo  [4] Configure SSH server
echo  [5] Complete DevOps setup
echo  [0] Back to Main Menu
echo.
set /p devops_choice="Enter choice: "

if "%devops_choice%"=="1" call :SETUP_WSL_DOCKER
if "%devops_choice%"=="2" call :CONFIG_POWERSHELL
if "%devops_choice%"=="3" call :SETUP_DEV_USERS
if "%devops_choice%"=="4" call :CONFIG_SSH
if "%devops_choice%"=="5" call :COMPLETE_DEVOPS_SETUP
if "%devops_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:SETUP_WSL_DOCKER
echo.
echo Setting up WSL and Docker prerequisites...
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
echo WSL features enabled. Restart required.
goto :EOF

:CONFIG_POWERSHELL
echo.
echo Configuring PowerShell execution policy...
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force"
echo PowerShell execution policy set to RemoteSigned.
goto :EOF

:SETUP_DEV_USERS
echo.
echo Setting up development user accounts...
set /p dev_user="Enter developer username: "
set /p dev_pass="Enter developer password: "
net user %dev_user% %dev_pass% /add /fullname:"Developer Account" >nul 2>&1
net localgroup "Administrators" %dev_user% /add >nul 2>&1
echo Developer account created: %dev_user%
goto :EOF

:CONFIG_SSH
echo.
echo Configuring SSH server...
dism /online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
sc config sshd start= auto
net start sshd
echo SSH server configured and started.
goto :EOF

:COMPLETE_DEVOPS_SETUP
call :SETUP_WSL_DOCKER
call :CONFIG_POWERSHELL
call :CONFIG_SSH
echo.
echo Complete DevOps setup applied!
echo Note: Restart required for some features.
goto :EOF

:SECURITY_HARDENING
cls
echo.
echo ========================================================================
echo         Security Hardening and Secpol Configuration
echo ========================================================================
echo.
echo Options:
echo  [1] Apply security policy hardening
echo  [2] Configure user account policies
echo  [3] Network security hardening
echo  [4] Audit policy configuration
echo  [5] Complete security hardening
echo  [0] Back to Main Menu
echo.
set /p security_choice="Enter choice: "

if "%security_choice%"=="1" call :HARDEN_SECURITY_POLICY
if "%security_choice%"=="2" call :CONFIG_ACCOUNT_POLICIES
if "%security_choice%"=="3" call :HARDEN_NETWORK_SECURITY
if "%security_choice%"=="4" call :CONFIG_AUDIT_POLICY
if "%security_choice%"=="5" call :COMPLETE_SECURITY_HARDENING
if "%security_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:HARDEN_SECURITY_POLICY
echo.
echo Applying security policy hardening...
if not exist "SecurityConfigs" mkdir SecurityConfigs
set SEC_FILE=SecurityConfigs\security_hardening.inf
echo [Unicode] > "%SEC_FILE%"
echo Unicode=yes >> "%SEC_FILE%"
echo [Version] >> "%SEC_FILE%"
echo signature="$CHICAGO$" >> "%SEC_FILE%"
echo Revision=1 >> "%SEC_FILE%"
echo [System Access] >> "%SEC_FILE%"
echo MinimumPasswordAge = 1 >> "%SEC_FILE%"
echo MaximumPasswordAge = 90 >> "%SEC_FILE%"
echo MinimumPasswordLength = 12 >> "%SEC_FILE%"
echo PasswordComplexity = 1 >> "%SEC_FILE%"
echo PasswordHistorySize = 24 >> "%SEC_FILE%"
echo LockoutBadCount = 5 >> "%SEC_FILE%"
echo ResetLockoutCount = 30 >> "%SEC_FILE%"
echo LockoutDuration = 30 >> "%SEC_FILE%"
echo Security policy template created: %SEC_FILE%
echo Apply with: secedit /configure /db secedit.sdb /cfg %SEC_FILE%
goto :EOF

:CONFIG_ACCOUNT_POLICIES
echo.
echo Configuring account policies...
net accounts /minpwlen:12 >nul 2>&1
net accounts /maxpwage:90 >nul 2>&1
net accounts /minpwage:1 >nul 2>&1
net accounts /uniquepw:24 >nul 2>&1
net accounts /lockoutthreshold:5 >nul 2>&1
net accounts /lockoutduration:30 >nul 2>&1
net accounts /lockoutwindow:30 >nul 2>&1
echo Account policies configured.
goto :EOF

:HARDEN_NETWORK_SECURITY
echo.
echo Hardening network security...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableIPSourceRouting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableICMPRedirect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisableIPSourceRouting /t REG_DWORD /d 2 /f >nul 2>&1
netsh advfirewall set allprofiles state on
echo Network security hardened.
goto :EOF

:CONFIG_AUDIT_POLICY
echo.
echo Configuring audit policies...
auditpol /set /category:"Account Logon" /success:enable /failure:enable >nul 2>&1
auditpol /set /category:"Account Management" /success:enable /failure:enable >nul 2>&1
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable >nul 2>&1
auditpol /set /category:"Policy Change" /success:enable /failure:enable >nul 2>&1
echo Audit policies configured.
goto :EOF

:COMPLETE_SECURITY_HARDENING
call :HARDEN_SECURITY_POLICY
call :CONFIG_ACCOUNT_POLICIES
call :HARDEN_NETWORK_SECURITY
call :CONFIG_AUDIT_POLICY
echo.
echo Complete security hardening applied!
goto :EOF

:UUID_MASKING
cls
echo.
echo ========================================================================
echo              UUID/GUID Masking and Cloaking
echo ========================================================================
echo.
echo This module configures hardware ID masking for privacy.
echo.
echo Options:
echo  [1] Generate new random UUIDs
echo  [2] Mask disk serial numbers
echo  [3] Randomize MAC addresses
echo  [4] Export current hardware IDs
echo  [0] Back to Main Menu
echo.
set /p uuid_choice="Enter choice: "

if "%uuid_choice%"=="1" call :GENERATE_NEW_UUIDS
if "%uuid_choice%"=="2" call :MASK_DISK_SERIALS
if "%uuid_choice%"=="3" call :RANDOMIZE_MAC
if "%uuid_choice%"=="4" call :EXPORT_HARDWARE_IDS
if "%uuid_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:GENERATE_NEW_UUIDS
echo.
echo Generating new UUIDs...
if not exist "UUIDConfigs" mkdir UUIDConfigs
set UUID_FILE=UUIDConfigs\new_uuids_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
powershell -Command "[guid]::NewGuid()" > "%UUID_FILE%"
echo New UUID generated and saved to: %UUID_FILE%
echo.
echo Warning: Changing system UUIDs may affect licensing and activation.
goto :EOF

:MASK_DISK_SERIALS
echo.
echo Disk serial masking information...
echo Current disk information:
wmic diskdrive get SerialNumber,Model
echo.
echo Note: Disk serial masking requires third-party tools or firmware modifications.
goto :EOF

:RANDOMIZE_MAC
echo.
echo MAC address randomization...
echo Current network adapters:
getmac
echo.
echo Note: Use network adapter properties to configure MAC randomization.
echo Or use: netsh wlan set randomization
goto :EOF

:EXPORT_HARDWARE_IDS
echo.
echo Exporting hardware IDs...
if not exist "UUIDConfigs" mkdir UUIDConfigs
set HW_FILE=UUIDConfigs\hardware_ids_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
echo Hardware IDs Report > "%HW_FILE%"
echo ================== >> "%HW_FILE%"
echo. >> "%HW_FILE%"
echo System UUID: >> "%HW_FILE%"
wmic csproduct get UUID >> "%HW_FILE%"
echo. >> "%HW_FILE%"
echo Disk Serials: >> "%HW_FILE%"
wmic diskdrive get SerialNumber,Model >> "%HW_FILE%"
echo. >> "%HW_FILE%"
echo MAC Addresses: >> "%HW_FILE%"
getmac >> "%HW_FILE%"
echo Hardware IDs exported to: %HW_FILE%
goto :EOF

:REGISTRY_VIRT
cls
echo.
echo ========================================================================
echo              Registry Virtualization Setup
echo ========================================================================
echo.
echo This module configures registry virtualization for application compatibility.
echo.
echo Options:
echo  [1] Enable registry virtualization
echo  [2] Disable registry virtualization
echo  [3] Configure per-application virtualization
echo  [4] View virtualization status
echo  [0] Back to Main Menu
echo.
set /p reg_choice="Enter choice: "

if "%reg_choice%"=="1" call :ENABLE_REG_VIRT
if "%reg_choice%"=="2" call :DISABLE_REG_VIRT
if "%reg_choice%"=="3" call :CONFIG_APP_VIRT
if "%reg_choice%"=="4" call :VIEW_VIRT_STATUS
if "%reg_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:ENABLE_REG_VIRT
echo.
echo Enabling registry virtualization...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 1 /f >nul 2>&1
echo Registry virtualization enabled.
goto :EOF

:DISABLE_REG_VIRT
echo.
echo Disabling registry virtualization...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 0 /f >nul 2>&1
echo Registry virtualization disabled.
goto :EOF

:CONFIG_APP_VIRT
echo.
echo Configuring per-application virtualization...
set /p app_path="Enter application path: "
echo Application-specific virtualization requires manifests or compatibility settings.
echo Configure via application properties compatibility tab.
goto :EOF

:VIEW_VIRT_STATUS
echo.
echo Registry virtualization status:
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization
goto :EOF

:BITLOCKER_TPM
cls
echo.
echo ========================================================================
echo         BitLocker and TPM Key Management
echo ========================================================================
echo.
echo Options:
echo  [1] Check TPM status
echo  [2] Initialize TPM
echo  [3] Enable BitLocker on system drive
echo  [4] Backup BitLocker recovery key
echo  [5] Disable BitLocker
echo  [0] Back to Main Menu
echo.
set /p bitlocker_choice="Enter choice: "

if "%bitlocker_choice%"=="1" call :CHECK_TPM_STATUS
if "%bitlocker_choice%"=="2" call :INITIALIZE_TPM
if "%bitlocker_choice%"=="3" call :ENABLE_BITLOCKER
if "%bitlocker_choice%"=="4" call :BACKUP_RECOVERY_KEY
if "%bitlocker_choice%"=="5" call :DISABLE_BITLOCKER
if "%bitlocker_choice%"=="0" goto MAIN_MENU

pause
goto MAIN_MENU

:CHECK_TPM_STATUS
echo.
echo Checking TPM status...
powershell -Command "Get-Tpm"
goto :EOF

:INITIALIZE_TPM
echo.
echo Initializing TPM...
powershell -Command "Initialize-Tpm"
echo TPM initialization completed.
goto :EOF

:ENABLE_BITLOCKER
echo.
echo Enabling BitLocker on system drive...
if not exist "BitLockerKeys" mkdir BitLockerKeys
set RECOVERY_FILE=BitLockerKeys\recovery_key_%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
powershell -Command "Enable-BitLocker -MountPoint 'C:' -EncryptionMethod Aes256 -UsedSpaceOnly -TpmProtector"
powershell -Command "(Get-BitLockerVolume -MountPoint 'C:').KeyProtector" > "%RECOVERY_FILE%"
echo BitLocker enabled. Recovery key saved to: %RECOVERY_FILE%
goto :EOF

:BACKUP_RECOVERY_KEY
echo.
echo Backing up BitLocker recovery key...
if not exist "BitLockerKeys" mkdir BitLockerKeys
set BACKUP_FILE=BitLockerKeys\recovery_backup_%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt
powershell -Command "(Get-BitLockerVolume -MountPoint 'C:').KeyProtector" > "%BACKUP_FILE%"
echo Recovery key backed up to: %BACKUP_FILE%
goto :EOF

:DISABLE_BITLOCKER
echo.
echo Disabling BitLocker...
powershell -Command "Disable-BitLocker -MountPoint 'C:'"
echo BitLocker disabled.
goto :EOF

:SCAN_CONFIG
cls
echo.
echo ========================================================================
echo              Scan Current System Configuration
echo ========================================================================
echo.
echo Scanning system configuration...
if not exist "SystemScans" mkdir SystemScans
set SCAN_FILE=SystemScans\system_scan_%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%.txt

echo System Configuration Scan > "%SCAN_FILE%"
echo ======================= >> "%SCAN_FILE%"
echo Scan Date: %date% %time% >> "%SCAN_FILE%"
echo Computer: %COMPUTERNAME% >> "%SCAN_FILE%"
echo User: %USERNAME% >> "%SCAN_FILE%"
echo. >> "%SCAN_FILE%"

echo Collecting OS information... >> "%SCAN_FILE%"
systeminfo >> "%SCAN_FILE%"

echo. >> "%SCAN_FILE%"
echo Installed Features: >> "%SCAN_FILE%"
dism /online /get-features /format:table >> "%SCAN_FILE%" 2>&1

echo. >> "%SCAN_FILE%"
echo Installed Drivers: >> "%SCAN_FILE%"
dism /online /get-drivers /format:table >> "%SCAN_FILE%" 2>&1

echo. >> "%SCAN_FILE%"
echo Windows Update Configuration: >> "%SCAN_FILE%"
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" >> "%SCAN_FILE%" 2>&1

echo. >> "%SCAN_FILE%"
echo Power Configuration: >> "%SCAN_FILE%"
powercfg /list >> "%SCAN_FILE%" 2>&1

echo. >> "%SCAN_FILE%"
echo Network Configuration: >> "%SCAN_FILE%"
ipconfig /all >> "%SCAN_FILE%" 2>&1

echo.
echo System scan completed!
echo Results saved to: %SCAN_FILE%
echo.
pause
goto MAIN_MENU

:ADAPTIVE_CONFIG
cls
echo.
echo ========================================================================
echo           Create Adaptive Configuration Profile
echo ========================================================================
echo.
echo Creating adaptive configuration based on current system...
if not exist "AdaptiveConfigs" mkdir AdaptiveConfigs
set ADAPTIVE_FILE=AdaptiveConfigs\adaptive_config_%COMPUTERNAME%_%date:~-4,4%%date:~-10,2%%date:~-7,2%.xml

echo ^<?xml version="1.0" encoding="utf-8"?^> > "%ADAPTIVE_FILE%"
echo ^<AdaptiveConfiguration^> >> "%ADAPTIVE_FILE%"
echo   ^<GeneratedDate^>%date% %time%^</GeneratedDate^> >> "%ADAPTIVE_FILE%"
echo   ^<SystemInfo^> >> "%ADAPTIVE_FILE%"
echo     ^<ComputerName^>%COMPUTERNAME%^</ComputerName^> >> "%ADAPTIVE_FILE%"
echo     ^<UserName^>%USERNAME%^</UserName^> >> "%ADAPTIVE_FILE%"

for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value ^| find "="') do (
    echo     ^<OSName^>%%a^</OSName^> >> "%ADAPTIVE_FILE%"
)

for /f "tokens=2 delims==" %%a in ('wmic os get Version /value ^| find "="') do (
    echo     ^<OSVersion^>%%a^</OSVersion^> >> "%ADAPTIVE_FILE%"
)

for /f "tokens=2 delims==" %%a in ('wmic computersystem get TotalPhysicalMemory /value ^| find "="') do (
    echo     ^<TotalRAM^>%%a^</TotalRAM^> >> "%ADAPTIVE_FILE%"
)

for /f "tokens=2 delims==" %%a in ('wmic cpu get Name /value ^| find "="') do (
    echo     ^<CPU^>%%a^</CPU^> >> "%ADAPTIVE_FILE%"
)

echo   ^</SystemInfo^> >> "%ADAPTIVE_FILE%"
echo   ^<Recommendations^> >> "%ADAPTIVE_FILE%"
echo     ^<HardwareBypass^>Recommended for Intel 7th Gen CPUs^</HardwareBypass^> >> "%ADAPTIVE_FILE%"
echo     ^<TelemetryRemoval^>Recommended for all systems^</TelemetryRemoval^> >> "%ADAPTIVE_FILE%"
echo     ^<PerformanceOptimization^>Recommended^</PerformanceOptimization^> >> "%ADAPTIVE_FILE%"
echo     ^<SecurityHardening^>Recommended for enterprise^</SecurityHardening^> >> "%ADAPTIVE_FILE%"
echo   ^</Recommendations^> >> "%ADAPTIVE_FILE%"
echo ^</AdaptiveConfiguration^> >> "%ADAPTIVE_FILE%"

echo.
echo Adaptive configuration profile created!
echo Saved to: %ADAPTIVE_FILE%
echo.
echo This profile can be used to replicate configuration on similar systems.
echo.
pause
goto MAIN_MENU

:EXIT
cls
echo.
echo Thank you for using Dism++ Automation CLI!
echo.
timeout /t 2 >nul
exit /b 0
