# Dism++ Automation Tools

## Overview

The Dism++ Automation Tools provide a comprehensive command-line interface for automating Windows deployment, configuration, and optimization tasks. This toolkit is designed for IT professionals, system administrators, and advanced users who need to streamline Windows system management.

## Quick Start

### Prerequisites

- Windows 10 or later
- Administrator privileges
- DISM (included with Windows)
- PowerShell 5.0 or later

### Installation

1. Clone or download the repository
2. Navigate to the repository directory
3. Right-click `DismAutomation.bat` and select "Run as administrator"

### Basic Usage

```batch
# Run the interactive CLI
DismAutomation.bat

# Follow the on-screen menu to select desired operations
```

## Features

### 🔧 System Configuration Replication
Replicate system configurations across multiple machines with support for:
- Windows Enterprise
- Windows Pro
- Windows Workstation Pro

**Use Case**: Deploy identical configurations to multiple workstations

### 🚫 Hardware Restriction Bypass
Remove installation blocks for unsupported hardware:
- Intel 7th Gen (7700K) processors on Windows 11
- TPM 2.0 requirements
- Secure Boot requirements
- RAM and storage minimums

**Use Case**: Install Windows 11 on older hardware

### 💾 Driver Injection
Inject drivers into Windows images (WIM/ESD):
- Ethernet drivers for network connectivity
- VMD (Intel Volume Management Device) drivers
- Storage controller drivers
- Custom hardware drivers

**Use Case**: Prepare Windows images with necessary drivers pre-installed

### 🎯 OOBE Skip
Automate or skip Windows Out-of-Box Experience:
- Complete OOBE bypass
- Selective screen skipping
- Auto-login configuration
- Network setup bypass

**Use Case**: Streamline Windows deployment without user interaction

### 🛡️ Telemetry and Tracker Removal
Remove Windows telemetry and tracking:
- Disable telemetry services
- Remove scheduled tasks
- Block telemetry domains
- Complete privacy configuration

**Use Case**: Enhance privacy and reduce network traffic

### ⚡ Performance Optimization
Comprehensive performance tuning:
- Multimedia Scheduling (MMCSS) optimization
- System responsiveness tuning
- WinRE optimization
- Dual boot configuration
- Network optimization

**Use Case**: Maximize system performance for specific workloads

### 👥 User Scaffolding
Automated user account management:
- Bulk user creation from CSV
- Default profile configuration
- Permission templates
- User configuration export

**Use Case**: Rapid user provisioning for new deployments

### 🔨 DevOps Configuration
Prepare systems for development workflows:
- WSL and Docker prerequisites
- PowerShell execution policy
- SSH server setup
- Development user accounts

**Use Case**: Configure developer workstations

### 🔐 Security Hardening
Implement security best practices:
- Account policy hardening
- Network security configuration
- Audit policy setup
- Security policy templates (CIS, NIST, DISA STIG compliant)

**Use Case**: Harden systems for enterprise deployment

### 🎭 UUID/GUID Masking
Hardware identifier management:
- UUID generation
- MAC address randomization
- Hardware ID export
- Privacy enhancement

**Use Case**: Privacy protection and hardware independence

### 📝 Registry Virtualization
Configure application compatibility:
- Enable/disable registry virtualization
- Per-application configuration
- Legacy application support

**Use Case**: Run legacy applications without admin rights

### 🔒 BitLocker and TPM Management
Encryption and security:
- TPM status and initialization
- BitLocker enablement
- Recovery key management
- Encryption configuration

**Use Case**: Secure sensitive data with full-disk encryption

### 🔍 System Scanning
Comprehensive system analysis:
- OS and hardware information
- Installed features and drivers
- Network and power configuration
- Complete system inventory

**Use Case**: Documentation and troubleshooting

### 🤖 Adaptive Configuration
Intelligent profile generation:
- Automatic system detection
- Smart recommendations
- Environment-based adaptation
- Configuration replication

**Use Case**: Create reusable configurations that adapt to different hardware

## File Structure

```
Dism-Multi-language/
├── DismAutomation.bat           # Main CLI interface
├── AUTOMATION_GUIDE.md          # Comprehensive documentation
├── README_AUTOMATION.md         # This file
├── ConfigProfiles/              # System configuration profiles
├── BypassConfigs/               # Hardware bypass configurations
├── OOBEConfigs/                 # OOBE skip configurations
├── TelemetryConfigs/            # Telemetry removal lists
├── SecurityConfigs/             # Security hardening templates
├── UserConfigs/                 # User account templates
├── UUIDConfigs/                 # Hardware identifier data
├── BitLockerKeys/               # BitLocker recovery keys
├── SystemScans/                 # System scan reports
└── AdaptiveConfigs/             # Adaptive configuration profiles
```

## Usage Examples

### Example 1: Install Windows 11 on Intel 7700K

1. Run `DismAutomation.bat` as Administrator
2. Select `[2] Hardware Restriction Bypass`
3. Confirm bypass application
4. Registry file created in `BypassConfigs/`
5. Apply registry file to Windows installation media or WIM image

### Example 2: Create Privacy-Focused Installation

1. Select `[5] Telemetry and Tracker Removal`
2. Choose `[4] Complete removal`
3. Select `[4] OOBE Skip Configuration`
4. Choose `[4] Complete OOBE skip`
5. Configurations saved for deployment

### Example 3: Bulk User Creation

1. Select `[7] User Scaffolding Automation`
2. Choose `[1] Create bulk users from CSV`
3. Edit the generated CSV template
4. Run again to create users automatically

### Example 4: DevOps Workstation Setup

1. Select `[8] DevOps Configuration Builder`
2. Choose `[5] Complete DevOps setup`
3. System configures WSL, Docker, PowerShell, and SSH
4. Restart system for changes to take effect

### Example 5: Adaptive Configuration Profile

1. Select `[14] Create Adaptive Configuration Profile`
2. Tool scans system automatically
3. Generates intelligent recommendations
4. Profile saved in `AdaptiveConfigs/`
5. Use profile to replicate configuration on similar systems

## Advanced Scenarios

### Enterprise Deployment Pipeline

```batch
# 1. Create base configuration
DismAutomation.bat -> [1] System Configuration Replicator -> Enterprise

# 2. Apply security hardening
DismAutomation.bat -> [9] Security Hardening -> [5] Complete

# 3. Configure telemetry removal
DismAutomation.bat -> [5] Telemetry Removal -> [4] Complete

# 4. Setup BitLocker
DismAutomation.bat -> [12] BitLocker and TPM -> [3] Enable BitLocker

# 5. Create adaptive profile
DismAutomation.bat -> [14] Adaptive Configuration
```

### Custom Image Creation

```batch
# 1. Mount Windows image
dism /Mount-Image /ImageFile:install.wim /Index:1 /MountDir:C:\Mount

# 2. Inject drivers
DismAutomation.bat -> [3] Driver Injection -> [4] All Drivers

# 3. Apply OOBE skip
Copy OOBEConfigs\unattend_oobe_bypass.xml to C:\Mount\Windows\Panther\

# 4. Apply hardware bypass
Copy BypassConfigs\HardwareBypass.reg to C:\Mount\Windows\

# 5. Commit changes
dism /Unmount-Image /MountDir:C:\Mount /Commit
```

## Configuration Files

### Config Profile Example

```xml
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
  <Edition>Enterprise</Edition>
  <Timestamp>2025-10-11 12:00:00</Timestamp>
  <Features>
    <OOBEBypass>true</OOBEBypass>
    <TelemetryRemoval>true</TelemetryRemoval>
    <PerformanceOptimization>true</PerformanceOptimization>
  </Features>
</Configuration>
```

### Hardware Bypass Registry

```registry
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
"BypassRAMCheck"=dword:00000001
"BypassCPUCheck"=dword:00000001
```

### OOBE Skip Unattend.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="oobeSystem">
    <component name="Microsoft-Windows-Shell-Setup">
      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
        <SkipUserOOBE>true</SkipUserOOBE>
      </OOBE>
    </component>
  </settings>
</unattend>
```

## Safety and Best Practices

### ⚠️ Important Warnings

1. **Always backup** your system before applying configurations
2. **Test in virtual machines** before production deployment
3. **Understand implications** of each configuration change
4. **Keep recovery keys** in secure, offline locations
5. **Document changes** for audit trail and troubleshooting

### 🔒 Security Considerations

- Hardware bypasses may reduce security posture
- UUID masking may violate license agreements
- Telemetry removal may affect Windows Update
- Always comply with organizational policies

### 📋 Best Practices

1. **Incremental Changes**: Apply one configuration at a time
2. **Testing**: Test configurations in non-production environments
3. **Documentation**: Document all applied configurations
4. **Backups**: Maintain system restore points
5. **Recovery**: Keep recovery media accessible
6. **Updates**: Keep tools and configurations current

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| "Access Denied" errors | Run as Administrator |
| BitLocker not available | Check TPM status and Windows edition |
| Driver injection fails | Verify driver compatibility, use `/ForceUnsigned` |
| Changes not applying | Restart or log out/in |
| Hardware bypass not working | Apply before Windows installation |

### Getting Help

1. Check `AUTOMATION_GUIDE.md` for detailed documentation
2. Review configuration files for errors
3. Check Windows Event Viewer for error details
4. Consult Dism++ documentation at www.chuyu.me
5. Report issues on GitHub repository

## Compatibility

### Windows Versions
- ✅ Windows 11 (all editions)
- ✅ Windows 10 (all editions)
- ✅ Windows Server 2022
- ✅ Windows Server 2019
- ✅ Windows Server 2016

### Processor Architectures
- ✅ x64 (AMD64)
- ✅ x86 (32-bit)
- ⚠️ ARM64 (limited support)

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test thoroughly
4. Submit pull request with documentation

## Legal and Compliance

### Disclaimer
This tool is provided for legitimate system administration purposes. Users are responsible for:
- Compliance with software licenses
- Adherence to organizational policies
- Following applicable laws and regulations
- Proper authorization before system modifications

### License
See repository LICENSE file for terms and conditions.

## Related Documentation

- [Main Repository README](README.md)
- [Comprehensive Automation Guide](AUTOMATION_GUIDE.md)
- [Dism++ Official Documentation](https://www.chuyu.me)
- [Microsoft DISM Documentation](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism)

## Version History

### Version 1.0 (2025-10-11)
- Initial release
- Full automation CLI interface
- 14 major feature categories
- Comprehensive documentation
- Adaptive configuration profiles

## Credits

Developed as part of the Dism-Multi-language project.

Special thanks to:
- Dism++ development team
- Contributors and translators
- Community testers and feedback providers

---

**For detailed documentation, see [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md)**
