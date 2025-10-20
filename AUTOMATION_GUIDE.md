# Dism++ Automation Guide

## Table of Contents
1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [System Configuration Replication](#system-configuration-replication)
4. [Hardware Restriction Bypass](#hardware-restriction-bypass)
5. [Driver Injection](#driver-injection)
6. [OOBE Skip Configuration](#oobe-skip-configuration)
7. [Telemetry and Tracker Removal](#telemetry-and-tracker-removal)
8. [Performance Optimization](#performance-optimization)
9. [User Scaffolding](#user-scaffolding)
10. [DevOps Configuration](#devops-configuration)
11. [Security Hardening](#security-hardening)
12. [UUID/GUID Masking](#uuid-guid-masking)
13. [Registry Virtualization](#registry-virtualization)
14. [BitLocker and TPM Management](#bitlocker-and-tpm-management)
15. [System Scanning](#system-scanning)
16. [Adaptive Configuration](#adaptive-configuration)

---

## Overview

The Dism++ Automation CLI provides a comprehensive batch interface for automating Windows system configuration, deployment, and optimization. This tool enables IT professionals and power users to:

- Replicate system configurations across multiple machines
- Bypass hardware restrictions for unsupported processors (e.g., Intel 7700K on Windows 11)
- Inject drivers into Windows images (WIM/ESD)
- Skip Windows Out-of-Box Experience (OOBE)
- Remove telemetry and tracking components
- Optimize system performance
- Automate user account management
- Configure DevOps environments
- Harden system security
- Manage hardware identifiers
- Configure BitLocker and TPM

---

## Getting Started

### Prerequisites

- Windows 10 or later
- Administrator privileges
- DISM (Deployment Image Servicing and Management) tool
- PowerShell 5.0 or later

### Running the Automation CLI

1. Open Command Prompt as Administrator
2. Navigate to the Dism++ directory
3. Run: `DismAutomation.bat`

The main menu will display all available automation options.

---

## System Configuration Replication

### Purpose
Replicate system configurations across multiple machines with different Windows editions (Enterprise, Pro, Workstation Pro).

### Features

#### Supported Windows Editions
- **Windows Enterprise**: Full feature set for enterprise deployments
- **Windows Pro**: Professional workstation configuration
- **Windows Workstation Pro**: High-performance workstation settings

#### Configuration Profile Creation

The tool creates XML configuration profiles that capture:
- System edition and version
- Installed features
- User accounts and permissions
- Network settings
- Performance optimizations
- Security policies

#### Usage

1. Select option `[1] System Configuration Replicator`
2. Choose Windows edition or auto-detect
3. Profile is saved to `ConfigProfiles\` directory

#### Profile Structure

```xml
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
  <Edition>Enterprise</Edition>
  <Timestamp>2025-10-11 12:00:00</Timestamp>
  <SystemInfo>
    <ComputerName>WORKSTATION01</ComputerName>
    <UserName>Administrator</UserName>
  </SystemInfo>
  <Features>
    <OOBEBypass>true</OOBEBypass>
    <TelemetryRemoval>true</TelemetryRemoval>
    <PerformanceOptimization>true</PerformanceOptimization>
  </Features>
</Configuration>
```

#### Deployment

To deploy a configuration profile:
1. Copy the XML profile to the target machine
2. Run the automation tool
3. Select the profile to apply
4. System will adapt settings to match the profile

---

## Hardware Restriction Bypass

### Purpose
Remove installation blocks for unsupported hardware configurations, particularly useful for:
- Intel 7th Gen (Kaby Lake) processors on Windows 11
- Systems without TPM 2.0
- Systems without Secure Boot
- Machines with insufficient RAM
- Storage size restrictions

### Technical Details

The bypass works by creating registry entries that disable hardware checks during Windows installation:

```registry
[HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
"BypassRAMCheck"=dword:00000001
"BypassCPUCheck"=dword:00000001
"BypassStorageCheck"=dword:00000001
```

### Usage

1. Select option `[2] Hardware Restriction Bypass`
2. Confirm bypass application
3. Registry file is created in `BypassConfigs\HardwareBypass.reg`
4. Apply to Windows image or installation media

### Intel 7700K Specific Configuration

For Intel 7700K and other 7th Gen processors:
- Disables CPU generation check
- Allows Windows 11 installation on Kaby Lake
- Maintains system stability
- Full feature support

### Important Notes

⚠️ **Warning**: Bypassing hardware requirements may result in:
- Reduced system stability
- Missing security features
- Potential compatibility issues
- No official Microsoft support

Use only when necessary and understand the implications.

---

## Driver Injection

### Purpose
Inject drivers into Windows installation images (WIM/ESD) for automated deployment, particularly useful for:
- Ethernet drivers (for network connectivity during setup)
- VMD (Intel Volume Management Device) drivers
- Storage controller drivers
- Custom hardware drivers

### Supported Driver Types

#### Ethernet Drivers
Essential for network-based installations and Windows Update during OOBE.

**Common scenarios**:
- Intel I219-V Ethernet
- Realtek PCIe GbE Family Controller
- Killer E2500 Gigabit Ethernet

#### VMD Drivers
Required for Intel Volume Management Device support on modern platforms.

**Platforms requiring VMD**:
- Intel 11th Gen (Rocket Lake) and newer
- High-end workstations
- Server-grade systems

#### Storage Drivers
Critical for systems with RAID, NVMe, or specialty storage controllers.

### Usage

1. Mount Windows image using DISM:
   ```batch
   dism /Mount-Image /ImageFile:C:\install.wim /Index:1 /MountDir:C:\Mount
   ```

2. Select option `[3] Driver Injection`
3. Choose driver type
4. Specify mount path and driver location
5. Tool injects drivers recursively

### Manual Driver Injection

For advanced users, drivers can be injected manually:

```batch
dism /Image:C:\Mount /Add-Driver /Driver:C:\Drivers /Recurse /ForceUnsigned
```

### Best Practices

- **Always use signed drivers** when possible
- **Test driver compatibility** before mass deployment
- **Keep driver packages organized** by type
- **Document driver versions** for troubleshooting
- **Maintain driver repository** for different hardware configurations

---

## OOBE Skip Configuration

### Purpose
Automate or skip the Windows Out-of-Box Experience (OOBE) for faster deployment and unattended installations.

### OOBE Skip Options

#### 1. Complete OOBE Bypass
Skip all OOBE screens including:
- EULA acceptance
- Privacy settings
- Cortana configuration
- Microsoft account creation
- Network setup
- Device customization

#### 2. Selective Skip
Choose specific OOBE screens to skip:
- Hide EULA page
- Hide OEM registration
- Hide online account screens
- Hide wireless setup
- Skip user OOBE
- Skip machine OOBE

#### 3. Auto-Login Configuration
Automatically log in to a specified user account after installation.

### Unattend.xml Configuration

The tool creates an `unattend.xml` file with OOBE settings:

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup">
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <ProtectYourPC>3</ProtectYourPC>
        <SkipUserOOBE>true</SkipUserOOBE>
        <SkipMachineOOBE>true</SkipMachineOOBE>
      </OOBE>
    </component>
  </settings>
</unattend>
```

### Network Setup Bypass

Windows 11 requires internet connection during OOBE. To bypass:

1. Use registry key:
   ```registry
   [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE]
   "BypassNRO"=dword:00000001
   ```

2. Or press `Shift + F10` during OOBE and run:
   ```batch
   OOBE\BYPASSNRO
   ```

### Usage

1. Select option `[4] OOBE Skip Configuration`
2. Choose desired options
3. Apply unattend.xml to Windows image or installation media

### Deployment Methods

- **Sysprep**: Include unattend.xml during image preparation
- **Installation Media**: Place in root of installation USB/ISO
- **WIM Injection**: Inject into Windows image before deployment

---

## Telemetry and Tracker Removal

### Purpose
Remove Windows telemetry, diagnostic data collection, and tracking components to enhance privacy and reduce network traffic.

### Components Removed/Disabled

#### Telemetry Services
- **DiagTrack**: Connected User Experiences and Telemetry
- **dmwappushservice**: WAP Push Message Routing Service
- **diagnosticshub.standardcollector.service**: Diagnostics Hub Standard Collector

#### Scheduled Tasks
- Application Experience tasks
- Customer Experience Improvement Program
- Disk Diagnostic data collector
- Windows Error Reporting

#### Network Connections
Blocked telemetry domains:
- vortex.data.microsoft.com
- telemetry.microsoft.com
- watson.telemetry.microsoft.com
- watson.live.com
- statsfe2.ws.microsoft.com
- reports.wes.df.telemetry.microsoft.com
- And 30+ additional telemetry endpoints

### Privacy Levels

#### Basic Telemetry Removal
- Disables main telemetry services
- Sets data collection to "Security" level
- Minimal impact on functionality

#### Moderate Removal
- Disables services and scheduled tasks
- Removes most telemetry components
- Some diagnostic features unavailable

#### Complete Removal
- All telemetry services disabled
- All telemetry tasks removed
- Network-level blocking via hosts file
- Maximum privacy, potential functionality loss

### Registry Modifications

```registry
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection]
"AllowTelemetry"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection]
"AllowTelemetry"=dword:00000000
```

### Usage

1. Select option `[5] Telemetry and Tracker Removal`
2. Choose removal level
3. System applies configurations
4. Restart required for full effect

### Hosts File Blocking

The tool creates a hosts file append with telemetry domain blocks:

```
0.0.0.0 vortex.data.microsoft.com
0.0.0.0 vortex-win.data.microsoft.com
0.0.0.0 telecommand.telemetry.microsoft.com
0.0.0.0 oca.telemetry.microsoft.com
0.0.0.0 sqm.telemetry.microsoft.com
```

### Important Considerations

⚠️ **Potential Issues**:
- Windows Update may be affected
- Microsoft Store functionality reduced
- Some features may not work properly
- Diagnostic tools unavailable

✅ **Recommended For**:
- Privacy-focused users
- Enterprise environments
- Systems without internet
- Reduced network usage

---

## Performance Optimization

### Purpose
Optimize Windows performance for various workload types including multimedia, gaming, professional applications, and general responsiveness.

### Optimization Categories

#### 1. Multimedia Scheduling (MMCSS)

Optimizes system for multimedia applications:

**Registry Settings**:
```registry
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile]
"SystemResponsiveness"=dword:0000000a
"NetworkThrottlingIndex"=dword:ffffffff

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games]
"GPU Priority"=dword:00000008
"Priority"=dword:00000006
"Scheduling Category"="High"
```

**Benefits**:
- Reduced audio/video latency
- Improved multimedia streaming
- Better gaming performance
- Prioritized GPU scheduling

#### 2. System Responsiveness Tuning

Reduces delays and improves UI responsiveness:

**Settings Applied**:
- Reduced WaitToKillServiceTimeout (2 seconds)
- Reduced WaitToKillAppTimeout (2 seconds)
- Reduced HungAppTimeout (1 second)
- AutoEndTasks enabled
- Menu show delay eliminated

**Impact**:
- Faster application launches
- Quicker shutdown times
- Reduced UI lag
- Improved multitasking

#### 3. WinRE (Windows Recovery Environment) Optimization

Optimizes the Windows Recovery Environment for faster boot and smaller footprint.

**Optimizations**:
- Compact WinRE image
- Remove unnecessary recovery tools
- Optimize boot configuration
- Reduce recovery partition size

**Commands**:
```batch
reagentc /info
reagentc /setreimage /path C:\Recovery\WindowsRE
```

#### 4. Dual Boot Configuration

Optimizes dual boot setup for faster boot times:

**Settings**:
- Configurable boot timeout
- Default OS selection
- Boot menu customization
- Boot order optimization

**BCD Edits**:
```batch
bcdedit /timeout 5
bcdedit /default {current}
bcdedit /displayorder {current} {other-os}
```

### Network Optimization

Removes network throttling for improved performance:

```registry
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile]
"NetworkThrottlingIndex"=dword:ffffffff
```

### Power Plan Optimization

Configures high-performance power plan:

```batch
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change monitor-timeout-ac 0
powercfg /change disk-timeout-ac 0
powercfg /change standby-timeout-ac 0
```

### Usage

1. Select option `[6] Performance Optimization Suite`
2. Choose specific optimization or complete suite
3. System applies optimizations
4. Restart recommended for full effect

### Performance Profiles

#### Gaming Profile
- Maximum GPU priority
- Network throttling disabled
- High system responsiveness
- Minimal background tasks

#### Workstation Profile
- Balanced CPU/GPU priorities
- Optimized for professional applications
- Multimedia scheduling enabled
- Enhanced multitasking

#### Server Profile
- Service timeout optimizations
- Network performance priority
- Background processing optimized
- Reduced UI overhead

---

## User Scaffolding

### Purpose
Automate user account creation, configuration, and management for rapid deployment across multiple systems.

### Features

#### 1. Bulk User Creation from CSV

Create multiple users from a CSV template:

**CSV Format**:
```csv
username,password,fullname,description
admin1,P@ssw0rd,Admin User 1,Administrator Account
user1,P@ssw0rd,Standard User 1,Standard User Account
dev1,P@ssw0rd,Developer 1,Development Account
```

**Process**:
1. Tool generates CSV template
2. Edit CSV with user details
3. Run bulk creation
4. Users are created automatically

#### 2. Default User Profile Configuration

Configure default profile for all new users:

**Customizable Elements**:
- Desktop shortcuts
- Start menu layout
- Taskbar configuration
- Registry settings
- Folder structure
- Application defaults

**Profile Location**: `C:\Users\Default\`

#### 3. User Permissions Templates

Pre-configured permission sets:

**Standard Users**:
- Read access to Program Files
- Write access to user profile only
- No administrative rights
- Limited system access

**Power Users**:
- Read/Write to most system areas
- Limited administrative tasks
- Elevated permissions for specific applications
- Can modify system settings

**Administrators**:
- Full system access
- All administrative privileges
- Can modify security policies
- Complete control

#### 4. User Configuration Export

Export current user configuration:

**Exported Data**:
- User accounts list
- Group memberships
- Permission assignments
- User policies
- Login scripts

### Usage

1. Select option `[7] User Scaffolding Automation`
2. Choose desired function
3. Follow prompts for configuration
4. Users created automatically

### Advanced Scenarios

#### Domain User Synchronization
```batch
net user /domain
dsquery user
```

#### Group Policy Integration
Link user templates with Group Policy Objects for centralized management.

#### Automated Password Management
- Password complexity enforcement
- Scheduled password changes
- Password history tracking
- Lockout policies

---

## DevOps Configuration

### Purpose
Configure Windows systems for DevOps workflows, development environments, and CI/CD pipelines.

### Components

#### 1. WSL and Docker Prerequisites

Enables Windows Subsystem for Linux and Docker support:

**Features Enabled**:
- Microsoft-Windows-Subsystem-Linux
- VirtualMachinePlatform
- Hyper-V (if available)

**Commands**:
```batch
dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

**Post-Installation**:
- Install WSL 2 kernel update
- Set WSL 2 as default
- Install preferred Linux distribution

#### 2. PowerShell Execution Policy

Configure PowerShell for script execution:

**Policy Levels**:
- **Restricted**: No scripts allowed (default)
- **AllSigned**: Only signed scripts
- **RemoteSigned**: Signed remote scripts required
- **Unrestricted**: All scripts allowed (development only)

**Recommended for DevOps**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

#### 3. Development User Accounts

Create specialized developer accounts:

**Features**:
- Administrator privileges
- Development tool access
- Custom environment variables
- Specialized permissions

**Security Considerations**:
- Use for development only
- Separate from production accounts
- Regular audit required
- Strong password policy

#### 4. SSH Server Configuration

Enable OpenSSH server for remote access:

**Installation**:
```batch
dism /online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
```

**Configuration**:
```batch
sc config sshd start=auto
net start sshd
```

**Firewall Rule**:
```batch
netsh advfirewall firewall add rule name="OpenSSH Server" dir=in action=allow protocol=TCP localport=22
```

### Usage

1. Select option `[8] DevOps Configuration Builder`
2. Choose components to install
3. System configures environment
4. Restart may be required

### Recommended Tools

After base configuration, install:
- **Git**: Version control
- **Docker Desktop**: Containerization
- **Visual Studio Code**: Code editor
- **Node.js**: JavaScript runtime
- **Python**: Scripting language
- **Azure CLI**: Cloud management
- **kubectl**: Kubernetes management

### CI/CD Integration

Configure for continuous integration:
- GitHub Actions runners
- Azure DevOps agents
- Jenkins nodes
- GitLab runners

---

## Security Hardening

### Purpose
Implement security best practices, harden system configuration, and protect against common vulnerabilities.

### Security Domains

#### 1. Account Policies

Password and account lockout policies:

**Password Policy**:
- Minimum length: 12 characters
- Maximum age: 90 days
- Minimum age: 1 day
- Complexity requirements: Enabled
- Password history: 24 passwords
- Reversible encryption: Disabled

**Lockout Policy**:
- Lockout threshold: 5 invalid attempts
- Lockout duration: 30 minutes
- Reset lockout counter: 30 minutes

**Implementation**:
```batch
net accounts /minpwlen:12
net accounts /maxpwage:90
net accounts /minpwage:1
net accounts /uniquepw:24
net accounts /lockoutthreshold:5
net accounts /lockoutduration:30
```

#### 2. User Rights Assignment

Configure user rights and privileges:

**Restricted Actions**:
- Access computer from network
- Allow log on locally
- Back up files and directories
- Change system time
- Debug programs
- Load device drivers
- Manage auditing and security log

#### 3. Network Security

Harden network configuration:

**TCP/IP Hardening**:
```registry
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters]
"DisableIPSourceRouting"=dword:00000002
"EnableICMPRedirect"=dword:00000000
"EnableDeadGWDetect"=dword:00000000
"KeepAliveTime"=dword:000493e0
"TcpMaxDataRetransmissions"=dword:00000003
```

**Firewall Configuration**:
```batch
netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
netsh advfirewall set allprofiles logging filename %systemroot%\system32\LogFiles\Firewall\pfirewall.log
```

#### 4. Audit Policy Configuration

Enable comprehensive auditing:

**Audit Categories**:
- Account Logon (Success and Failure)
- Account Management (Success and Failure)
- Logon/Logoff (Success and Failure)
- Object Access (Failure only)
- Policy Change (Success and Failure)
- Privilege Use (Failure only)
- System Events (Success and Failure)

**Commands**:
```batch
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Account Management" /success:enable /failure:enable
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Policy Change" /success:enable /failure:enable
```

#### 5. Security Policy Templates

Generate security policy configuration files:

**Template Example** (`security_hardening.inf`):
```ini
[Unicode]
Unicode=yes
[Version]
signature="$CHICAGO$"
Revision=1
[System Access]
MinimumPasswordAge = 1
MaximumPasswordAge = 90
MinimumPasswordLength = 12
PasswordComplexity = 1
PasswordHistorySize = 24
LockoutBadCount = 5
ResetLockoutCount = 30
LockoutDuration = 30
```

**Application**:
```batch
secedit /configure /db secedit.sdb /cfg security_hardening.inf
```

### Usage

1. Select option `[9] Security Hardening`
2. Choose hardening level
3. System applies security configurations
4. Restart required for full effect

### Compliance Standards

Configurations align with:
- **CIS Benchmarks**: Center for Internet Security guidelines
- **NIST**: National Institute of Standards and Technology
- **DISA STIGs**: Defense Information Systems Agency Security Technical Implementation Guides
- **ISO 27001**: Information security management

### Security Checklist

- [ ] Strong password policies enforced
- [ ] Account lockout configured
- [ ] Firewall enabled and configured
- [ ] Audit policies active
- [ ] Unnecessary services disabled
- [ ] Administrative privileges limited
- [ ] Security updates current
- [ ] Antivirus/anti-malware active
- [ ] BitLocker enabled (if applicable)
- [ ] Backups configured

---

## UUID/GUID Masking

### Purpose
Configure hardware identifier masking for privacy, security, and hardware independence.

### Hardware Identifiers

#### System UUID
Unique identifier assigned to the computer by the manufacturer:
- Stored in BIOS/UEFI
- Used for licensing and asset tracking
- Can be modified in some systems

#### Disk Serial Numbers
Unique identifiers for storage devices:
- Assigned by manufacturer
- Used for hardware tracking
- Difficult to modify without firmware tools

#### MAC Addresses
Network adapter hardware addresses:
- 48-bit identifier
- Globally unique
- Can be randomized in software

#### Other Identifiers
- Machine GUID
- Product ID
- Installation ID
- Windows Update ID

### Masking Techniques

#### 1. UUID Generation

Generate new random UUIDs:
```powershell
[guid]::NewGuid()
```

**Output Example**:
```
a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

#### 2. MAC Address Randomization

Enable in Windows:
```batch
netsh wlan set randomization enabled=yes
```

**Per-Network Randomization**:
- Windows 10/11 supports MAC randomization
- Can be configured per network
- Enhances privacy on public networks

#### 3. Machine GUID Modification

Location:
```registry
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography]
"MachineGuid"="..."
```

**Caution**: Modifying may affect:
- Windows activation
- Some applications
- Hardware-based licenses

#### 4. Hardware ID Export

Export current hardware identifiers:
- System UUID
- Disk serial numbers
- MAC addresses
- Machine GUID
- CPU ID
- Motherboard serial

### Usage

1. Select option `[10] UUID/GUID Masking`
2. Choose masking operation
3. Review warnings
4. Apply changes carefully

### Privacy Considerations

**Benefits**:
- Enhanced privacy
- Hardware independence
- Anti-tracking
- Clone protection

**Risks**:
- Licensing issues
- Activation problems
- Hardware warranty concerns
- Compliance violations

### Legal and Ethical Considerations

⚠️ **Warning**: UUID/GUID masking may:
- Violate software license agreements
- Circumvent hardware-based security
- Break regulatory compliance
- Void warranties

Use only in legitimate scenarios:
- Privacy protection
- Virtual machine management
- Hardware testing
- Legal asset management

---

## Registry Virtualization

### Purpose
Enable registry virtualization for application compatibility, sandboxing, and legacy application support.

### Concept

Registry virtualization redirects registry writes from protected locations to user-specific locations:

**Protected Locations** (Virtualized):
- `HKEY_LOCAL_MACHINE\Software`
- System-wide configuration keys

**Virtual Locations** (Per-User):
- `HKEY_CURRENT_USER\Software\Classes\VirtualStore\Machine\Software`

### Use Cases

#### Legacy Application Support
Applications requiring admin rights for registry writes can run as standard user.

#### Application Sandboxing
Isolate application configuration changes from system-wide registry.

#### Testing and Development
Test registry changes without affecting system configuration.

#### Multi-User Environments
Allow users to have separate application configurations.

### Configuration

#### Enable Globally
```registry
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"EnableVirtualization"=dword:00000001
```

#### Disable for Specific Applications
Add manifest to application:
```xml
<trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
  <security>
    <requestedPrivileges>
      <requestedExecutionLevel level="asInvoker" uiAccess="false"/>
    </requestedPrivileges>
  </security>
</trustInfo>
```

#### Per-Application Control
Use application compatibility toolkit to configure virtualization per application.

### Usage

1. Select option `[11] Registry Virtualization Setup`
2. Choose enable, disable, or per-application
3. System applies configuration
4. Logout/login may be required

### Compatibility Considerations

**Works Well With**:
- Legacy 32-bit applications
- Applications designed for Windows XP/Vista
- Applications expecting write access to HKLM

**May Cause Issues With**:
- Applications checking actual registry locations
- Applications requiring system-wide configuration
- Applications with inter-process communication
- Security software

### Virtualization Hierarchy

1. **User attempts registry write** to `HKLM\Software\App`
2. **System checks** if virtualization is enabled
3. **System checks** if application manifest disables virtualization
4. **If enabled**: Write redirected to `HKCU\...\VirtualStore\Machine\Software\App`
5. **Application reads**: System merges virtualized and real registry data

### Monitoring Virtualization

Check which keys are virtualized:
```batch
reg query "HKCU\Software\Classes\VirtualStore\Machine\Software"
```

View per-process virtualization status:
```powershell
Get-Process | Select-Object Name, VirtualizationEnabled
```

---

## BitLocker and TPM Management

### Purpose
Configure and manage BitLocker Drive Encryption and Trusted Platform Module (TPM) for data protection and security.

### TPM (Trusted Platform Module)

#### Overview
Hardware security chip providing:
- Cryptographic key storage
- Secure boot verification
- BitLocker key protection
- Credential protection
- Platform integrity validation

#### TPM Versions
- **TPM 1.2**: Older standard, limited features
- **TPM 2.0**: Current standard, required for Windows 11

#### Checking TPM Status
```powershell
Get-Tpm
```

**Output Information**:
- TPM present
- TPM ready
- TPM enabled
- TPM activated
- TPM version

#### Initializing TPM
```powershell
Initialize-Tpm
```

**Process**:
1. Owner authorization value generated
2. Endorsement key created
3. Storage root key created
4. TPM ownership taken

### BitLocker Drive Encryption

#### Overview
Full-disk encryption for Windows volumes:
- Transparent to users
- Automatic encryption/decryption
- Pre-boot authentication available
- Recovery key backup

#### Encryption Methods
- **AES-128**: Balanced security and performance
- **AES-256**: Maximum security (recommended)
- **XTS-AES**: Best for modern systems

#### Protection Methods
- **TPM Only**: Automatic unlock with TPM
- **TPM + PIN**: Requires PIN at boot
- **TPM + Startup Key**: Requires USB key
- **TPM + PIN + Startup Key**: Maximum security
- **Password Only**: For systems without TPM
- **Recovery Key**: Backup method

### BitLocker Configuration

#### Enable BitLocker on System Drive
```powershell
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -UsedSpaceOnly -TpmProtector
```

**Parameters**:
- **-MountPoint**: Drive to encrypt (C:, D:, etc.)
- **-EncryptionMethod**: AES128, AES256, or XTS-AES
- **-UsedSpaceOnly**: Encrypt only used space (faster initial encryption)
- **-TpmProtector**: Use TPM for key protection

#### Add PIN Protection
```powershell
Add-BitLockerKeyProtector -MountPoint "C:" -Pin $SecurePin -TpmAndPinProtector
```

#### Add Recovery Key
```powershell
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector
```

#### Backup Recovery Key
```powershell
(Get-BitLockerVolume -MountPoint "C:").KeyProtector | Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}
```

Save to file:
```powershell
Backup-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId "{ID}" -FilePath "C:\BitLockerKeys\"
```

#### Check BitLocker Status
```powershell
Get-BitLockerVolume
```

**Status Information**:
- Volume path
- Encryption percentage
- Encryption method
- Volume status
- Protection status
- Key protectors

#### Disable BitLocker
```powershell
Disable-BitLocker -MountPoint "C:"
```

**Process**:
1. Decryption starts
2. Data remains accessible
3. Decryption completes in background
4. BitLocker removed when complete

### Usage

1. Select option `[12] BitLocker and TPM Key Management`
2. Choose desired operation
3. Follow prompts for configuration
4. Save recovery keys securely

### Best Practices

#### Recovery Key Management
- **Save to multiple locations**:
  - USB drive (offline)
  - Network share (secure)
  - Azure AD (cloud backup)
  - Printed copy (safe storage)
- **Document recovery procedures**
- **Test recovery process**
- **Update after hardware changes**

#### Performance Considerations
- **Use hardware acceleration** (AES-NI on modern CPUs)
- **Encrypt only used space** for faster initial encryption
- **Minimal performance impact** on modern hardware
- **SSD optimization** with hardware encryption

#### Security Recommendations
- **Use TPM + PIN** for sensitive systems
- **Enable pre-boot authentication**
- **Regular recovery key backups**
- **Monitor BitLocker status**
- **Update TPM firmware**
- **Secure boot enabled**

### Troubleshooting

#### TPM Not Found
- Check BIOS/UEFI settings
- Enable TPM in firmware
- Update TPM driver
- Verify hardware support

#### BitLocker Suspended
```powershell
Resume-BitLocker -MountPoint "C:"
```

#### Recovery Mode Boot
- System changes detected
- TPM cleared
- Hardware modifications
- BIOS/UEFI changes

**Resolution**:
1. Enter recovery key
2. Boot to Windows
3. Check BitLocker status
4. Re-enable protection if needed

---

## System Scanning

### Purpose
Comprehensive system configuration scan for documentation, troubleshooting, and configuration replication.

### Scan Components

#### 1. Operating System Information
- OS name and edition
- Version and build number
- Installation date
- System architecture (x86/x64/ARM)
- System root path
- Boot configuration

#### 2. Hardware Information
- Processor details
- Total physical memory
- Disk configuration
- Network adapters
- Graphics adapters
- BIOS/UEFI information

#### 3. Installed Features
Complete list of Windows features:
```batch
dism /online /get-features
```

**Categories**:
- Windows features
- Optional features
- Capabilities
- Language packs
- Updates

#### 4. Installed Drivers
Driver inventory:
```batch
dism /online /get-drivers
```

**Information**:
- Driver name
- Provider
- Date
- Version
- Class
- Signed status

#### 5. Windows Update Configuration
- Update policies
- WSUS configuration
- Automatic update settings
- Update history
- Pending updates

#### 6. Network Configuration
- IP addresses
- Subnet masks
- Default gateway
- DNS servers
- DHCP status
- Adapter MAC addresses

#### 7. Power Configuration
- Active power plan
- Power scheme GUIDs
- Sleep settings
- Display timeout
- Disk timeout

### Scan Output

#### Report Structure
```
System Configuration Scan
=======================
Scan Date: 2025-10-11 12:00:00
Computer: WORKSTATION01
User: Administrator

OS Information:
---------------
Name: Windows 11 Pro
Version: 10.0.22621
Architecture: x64
Install Date: 2025-01-15

Hardware:
---------
CPU: Intel Core i7-7700K @ 4.20GHz
RAM: 32 GB
Disk: 1 TB NVMe SSD

[Additional sections...]
```

### Usage

1. Select option `[13] Scan Current System Configuration`
2. Scan executes automatically
3. Report saved to `SystemScans\` directory
4. Review report for system details

### Use Cases

#### Documentation
- System inventory
- Configuration baseline
- Audit trail
- Compliance reporting

#### Troubleshooting
- Configuration comparison
- Missing driver identification
- Feature status verification
- Update status check

#### Deployment Planning
- Hardware compatibility check
- Driver requirements
- Feature dependencies
- Configuration replication

### Automated Scanning

Schedule regular scans:
```batch
schtasks /create /tn "System Scan" /tr "C:\DismAutomation.bat /scan" /sc weekly
```

### Report Formats

#### Text Format
Human-readable text file with configuration details.

#### XML Format
Machine-readable format for automated processing:
```xml
<SystemScan>
  <Date>2025-10-11</Date>
  <Computer>WORKSTATION01</Computer>
  <OS>
    <Name>Windows 11 Pro</Name>
    <Version>10.0.22621</Version>
  </OS>
  <!-- ... -->
</SystemScan>
```

#### JSON Format
For integration with monitoring tools and APIs.

---

## Adaptive Configuration

### Purpose
Create intelligent configuration profiles that automatically adapt to target system capabilities and requirements.

### Adaptive Intelligence

#### System Detection
Automatically detects:
- Operating system edition and version
- Hardware capabilities (CPU, RAM, storage)
- Installed features and roles
- Network configuration
- Security posture
- Performance characteristics

#### Recommendation Engine
Analyzes system and recommends:
- Hardware bypass requirements
- Performance optimizations
- Security hardening options
- Driver injection needs
- Feature configurations

#### Environment Adaptation
Adapts configuration based on:
- **Enterprise**: Maximum security, centralized management
- **Workstation**: Performance optimization, professional tools
- **Gaming**: Performance priority, minimal overhead
- **Server**: Reliability, service optimization
- **HTPC**: Multimedia optimization, power management

### Adaptive Profile Structure

```xml
<?xml version="1.0" encoding="utf-8"?>
<AdaptiveConfiguration>
  <GeneratedDate>2025-10-11 12:00:00</GeneratedDate>
  <SystemInfo>
    <ComputerName>WORKSTATION01</ComputerName>
    <UserName>Administrator</UserName>
    <OSName>Windows 11 Pro</OSName>
    <OSVersion>10.0.22621</OSVersion>
    <TotalRAM>34359738368</TotalRAM>
    <CPU>Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz</CPU>
  </SystemInfo>
  <DetectedEnvironment>
    <Type>Workstation</Type>
    <Purpose>Development</Purpose>
    <NetworkType>Enterprise</NetworkType>
  </DetectedEnvironment>
  <Recommendations>
    <HardwareBypass>
      <Enabled>true</Enabled>
      <Reason>Intel 7th Gen CPU - Windows 11 requires bypass</Reason>
      <Priority>High</Priority>
    </HardwareBypass>
    <TelemetryRemoval>
      <Enabled>true</Enabled>
      <Level>Moderate</Level>
      <Priority>Medium</Priority>
    </TelemetryRemoval>
    <PerformanceOptimization>
      <Enabled>true</Enabled>
      <Profile>Workstation</Profile>
      <Priority>High</Priority>
    </PerformanceOptimization>
    <SecurityHardening>
      <Enabled>true</Enabled>
      <Level>Enterprise</Level>
      <Priority>High</Priority>
    </SecurityHardening>
    <DriverInjection>
      <Required>false</Required>
      <Recommended>
        <Driver type="Ethernet">Intel I219-V</Driver>
        <Driver type="Storage">VMD Controller</Driver>
      </Recommended>
    </DriverInjection>
  </Recommendations>
  <AdaptiveSettings>
    <OOBE>
      <Skip>true</Skip>
      <AutoLogin>false</AutoLogin>
    </OOBE>
    <Telemetry>
      <Level>Security</Level>
      <BlockDomains>true</BlockDomains>
    </Telemetry>
    <Performance>
      <MMCSS>Optimized</MMCSS>
      <NetworkThrottling>Disabled</NetworkThrottling>
      <SystemResponsiveness>High</SystemResponsiveness>
    </Performance>
    <Security>
      <PasswordPolicy>Strong</PasswordPolicy>
      <FirewallEnabled>true</FirewallEnabled>
      <AuditingEnabled>true</AuditingEnabled>
      <BitLocker>Recommended</BitLocker>
    </Security>
  </AdaptiveSettings>
</AdaptiveConfiguration>
```

### Intelligence Features

#### Hardware-Based Adaptation
- **7th Gen Intel CPU**: Automatically recommends hardware bypass
- **Low RAM (<8GB)**: Suggests lightweight configurations
- **SSD Detected**: Enables SSD optimizations
- **Multiple GPUs**: Configures GPU scheduling
- **High-end CPU**: Enables performance features

#### Workload Detection
- **Development Tools**: Configures DevOps environment
- **Gaming Software**: Applies gaming optimizations
- **Server Roles**: Enables server optimizations
- **Multimedia Apps**: Configures MMCSS

#### Network Environment
- **Domain Joined**: Enterprise security profile
- **Workgroup**: Standalone optimizations
- **Public Network**: Enhanced security
- **Private Network**: Balanced configuration

### Usage

1. Select option `[14] Create Adaptive Configuration Profile`
2. Tool scans system automatically
3. Analyzes configuration and environment
4. Generates recommendations
5. Profile saved for replication

### Profile Application

To apply adaptive profile to new system:
1. Copy XML profile to target
2. Run automation tool
3. Tool reads profile
4. Applies configuration automatically
5. Adapts to target hardware
6. Verifies compatibility

### Machine Learning Integration

Future versions may include:
- Historical configuration analysis
- Usage pattern detection
- Predictive optimization
- Automated troubleshooting
- Continuous adaptation

### Benefits

- **Reduced Configuration Time**: Automatic detection and recommendation
- **Consistency**: Standardized configurations across similar systems
- **Intelligence**: Smart recommendations based on system analysis
- **Flexibility**: Adapts to different hardware and requirements
- **Documentation**: Self-documenting configurations

---

## Appendix

### Command Reference

#### DISM Commands
```batch
# Mount image
dism /Mount-Image /ImageFile:install.wim /Index:1 /MountDir:C:\Mount

# Inject drivers
dism /Image:C:\Mount /Add-Driver /Driver:C:\Drivers /Recurse

# Add features
dism /Image:C:\Mount /Enable-Feature /FeatureName:NetFx3

# Commit changes
dism /Unmount-Image /MountDir:C:\Mount /Commit
```

#### Registry Commands
```batch
# Export key
reg export HKLM\Software\App C:\backup.reg

# Import key
reg import C:\backup.reg

# Add value
reg add HKLM\Software\App /v Setting /t REG_DWORD /d 1 /f

# Delete value
reg delete HKLM\Software\App /v Setting /f
```

#### PowerShell Commands
```powershell
# Get TPM status
Get-Tpm

# Enable BitLocker
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -TpmProtector

# Set execution policy
Set-ExecutionPolicy RemoteSigned

# Get system info
Get-ComputerInfo
```

### File Locations

| File Type | Location |
|-----------|----------|
| Configuration Profiles | `ConfigProfiles\` |
| Hardware Bypass | `BypassConfigs\` |
| OOBE Settings | `OOBEConfigs\` |
| Telemetry Lists | `TelemetryConfigs\` |
| User Templates | `UserConfigs\` |
| Security Policies | `SecurityConfigs\` |
| UUID/GUID Data | `UUIDConfigs\` |
| BitLocker Keys | `BitLockerKeys\` |
| System Scans | `SystemScans\` |
| Adaptive Profiles | `AdaptiveConfigs\` |

### Troubleshooting

#### Common Issues

**Issue**: DISM commands fail with "access denied"
**Solution**: Run as Administrator

**Issue**: BitLocker not available
**Solution**: Check TPM availability and Windows edition

**Issue**: Driver injection fails
**Solution**: Verify driver compatibility and use `/ForceUnsigned` if needed

**Issue**: Registry changes not applying
**Solution**: Restart or log out/log in

**Issue**: Hardware bypass not working
**Solution**: Ensure registry file is applied before installation

### Security Warnings

⚠️ **Important Security Considerations**:
- Always back up system before applying configurations
- Test changes in non-production environment first
- Understand implications of security modifications
- Keep recovery keys in secure location
- Document all changes for audit trail
- Regularly review and update security policies

### Legal Disclaimer

This automation tool is provided for legitimate system administration and configuration purposes. Users are responsible for:
- Compliance with software licenses
- Adherence to organizational policies
- Following applicable laws and regulations
- Proper authorization before system modifications
- Data protection and privacy requirements

### Support and Resources

- **Dism++ Official Documentation**: [www.chuyu.me](https://www.chuyu.me)
- **GitHub Repository**: Issues and contributions
- **Community Forums**: User discussions and support
- **Microsoft Documentation**: Official Windows guidance

---

**Version**: 1.0
**Last Updated**: 2025-10-11
**Authors**: Dism++ Automation Project Contributors
**License**: See repository LICENSE file
