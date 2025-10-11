# Dism++ Automation Quick Start Guide

## 5-Minute Quick Start

### Step 1: Launch the Tool
1. Open Command Prompt as Administrator
2. Navigate to the Dism-Multi-language folder
3. Run: `DismAutomation.bat`

### Step 2: Choose Your Task

#### Most Common Tasks:

**Task 1: Install Windows 11 on Unsupported Hardware (Intel 7700K)**
```
Menu Selection: [2] Hardware Restriction Bypass
-> Confirm: Y
-> Result: Registry file created in BypassConfigs/
-> Next: Apply registry to Windows installation media
```

**Task 2: Remove Telemetry for Privacy**
```
Menu Selection: [5] Telemetry and Tracker Removal
-> Choose: [4] Complete removal
-> Result: Telemetry disabled, tasks removed, domains blocked
-> Restart required
```

**Task 3: Skip Windows Setup (OOBE)**
```
Menu Selection: [4] OOBE Skip Configuration
-> Choose: [4] Complete OOBE skip
-> Result: Unattend.xml created in OOBEConfigs/
-> Next: Add to Windows image or installation media
```

**Task 4: Optimize System Performance**
```
Menu Selection: [6] Performance Optimization Suite
-> Choose: [5] Complete Performance Suite
-> Result: MMCSS optimized, responsiveness improved
-> Restart recommended
```

**Task 5: Scan Current System**
```
Menu Selection: [13] Scan Current System Configuration
-> Result: Complete system report in SystemScans/
-> Use for: Documentation, troubleshooting, replication
```

## Common Workflows

### Workflow 1: Clean Windows Install (Privacy-Focused)

```batch
# Step 1: Create bootable USB with Windows 11
# Use Rufus or Media Creation Tool

# Step 2: Apply hardware bypass (if needed)
DismAutomation.bat -> [2] -> Y
# Copy BypassConfigs/HardwareBypass.reg to USB

# Step 3: Create OOBE skip
DismAutomation.bat -> [4] -> [4]
# Copy OOBEConfigs/unattend_oobe_bypass.xml to USB root

# Step 4: Install Windows from USB
# Hardware bypass and OOBE skip will apply automatically

# Step 5: After installation, remove telemetry
DismAutomation.bat -> [5] -> [4]

# Step 6: Optimize performance
DismAutomation.bat -> [6] -> [5]
```

### Workflow 2: Enterprise Deployment Preparation

```batch
# Step 1: Create configuration profile
DismAutomation.bat -> [1] -> [1] (Enterprise)

# Step 2: Apply security hardening
DismAutomation.bat -> [9] -> [5] (Complete)

# Step 3: Configure user scaffolding
DismAutomation.bat -> [7] -> [1] (Bulk users)
# Edit CSV and run again

# Step 4: Setup BitLocker
DismAutomation.bat -> [12] -> [3] (Enable)

# Step 5: Create adaptive profile for replication
DismAutomation.bat -> [14]
```

### Workflow 3: Developer Workstation Setup

```batch
# Step 1: Install WSL and Docker prerequisites
DismAutomation.bat -> [8] -> [1]
# Restart required

# Step 2: Configure PowerShell
DismAutomation.bat -> [8] -> [2]

# Step 3: Setup SSH server
DismAutomation.bat -> [8] -> [4]

# Step 4: Create developer account
DismAutomation.bat -> [8] -> [3]

# Step 5: Optimize for performance
DismAutomation.bat -> [6] -> [5]
```

### Workflow 4: Custom Windows Image with Drivers

```batch
# Step 1: Mount Windows image
dism /Mount-Image /ImageFile:C:\install.wim /Index:1 /MountDir:C:\Mount

# Step 2: Inject drivers using automation tool
DismAutomation.bat -> [3] -> [4] (All drivers)
# Enter mount path: C:\Mount
# Enter driver path: C:\Drivers

# Step 3: Apply OOBE skip (optional)
copy OOBEConfigs\unattend_oobe_bypass.xml C:\Mount\Windows\Panther\

# Step 4: Apply hardware bypass (optional)
copy BypassConfigs\HardwareBypass.reg C:\Mount\Windows\

# Step 5: Unmount and save
dism /Unmount-Image /MountDir:C:\Mount /Commit
```

## Quick Reference Commands

### DISM Commands
```batch
# List images in WIM
dism /Get-ImageInfo /ImageFile:install.wim

# Mount image
dism /Mount-Image /ImageFile:install.wim /Index:1 /MountDir:C:\Mount

# Inject drivers
dism /Image:C:\Mount /Add-Driver /Driver:C:\Drivers /Recurse

# Check image health
dism /Image:C:\Mount /Cleanup-Image /CheckHealth

# Unmount and commit
dism /Unmount-Image /MountDir:C:\Mount /Commit

# Unmount and discard
dism /Unmount-Image /MountDir:C:\Mount /Discard
```

### PowerShell Commands
```powershell
# Check TPM status
Get-Tpm

# Enable BitLocker
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -TpmProtector

# Get BitLocker status
Get-BitLockerVolume

# Export user list
Get-LocalUser | Export-Csv users.csv

# Check Windows version
Get-ComputerInfo | Select WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
```

### Registry Commands
```batch
# Export registry key
reg export HKLM\SYSTEM\Setup\LabConfig backup.reg

# Import registry key
reg import backup.reg

# Add registry value
reg add HKLM\SYSTEM\Setup\LabConfig /v BypassTPMCheck /t REG_DWORD /d 1 /f

# Query registry value
reg query HKLM\SYSTEM\Setup\LabConfig
```

## Troubleshooting Quick Fixes

### Problem: "Access Denied"
**Solution**: Right-click Command Prompt -> "Run as administrator"

### Problem: BitLocker not working
**Solution**: 
```batch
# Check TPM
powershell -Command "Get-Tpm"

# If TPM not ready
powershell -Command "Initialize-Tpm"
```

### Problem: Hardware bypass not working
**Solution**: Registry must be applied BEFORE installation starts
- For USB: Copy .reg file to USB root
- For WIM: Copy to C:\Mount\Windows\ before unmounting

### Problem: OOBE still showing
**Solution**: Verify unattend.xml placement
- USB install: Root of USB drive as "autounattend.xml"
- WIM inject: C:\Mount\Windows\Panther\unattend.xml

### Problem: Telemetry still active
**Solution**: 
```batch
# Rerun telemetry removal
DismAutomation.bat -> [5] -> [4]

# Then restart system
shutdown /r /t 0
```

### Problem: Drivers not loading
**Solution**:
```batch
# Verify drivers are signed
# Use /ForceUnsigned if necessary
dism /Image:C:\Mount /Add-Driver /Driver:C:\Drivers /Recurse /ForceUnsigned
```

## Configuration File Locations

After running the automation tool, files are saved to:

| Configuration Type | Location | Usage |
|-------------------|----------|-------|
| System Profiles | `ConfigProfiles/*.xml` | Configuration replication |
| Hardware Bypass | `BypassConfigs/*.reg` | Apply to Windows install |
| OOBE Skip | `OOBEConfigs/*.xml` | Rename to autounattend.xml |
| Telemetry Lists | `TelemetryConfigs/*.txt` | Append to hosts file |
| Security Policies | `SecurityConfigs/*.inf` | Apply with secedit |
| User Templates | `UserConfigs/*.csv` | Bulk user creation |
| BitLocker Keys | `BitLockerKeys/*.txt` | BACKUP SECURELY |
| System Scans | `SystemScans/*.txt` | Documentation |
| Adaptive Profiles | `AdaptiveConfigs/*.xml` | Smart replication |

## Safety Checklist

Before making changes:
- [ ] Back up important data
- [ ] Create system restore point
- [ ] Test in virtual machine first
- [ ] Read relevant documentation
- [ ] Understand what will change

After making changes:
- [ ] Verify system boots properly
- [ ] Check critical applications work
- [ ] Save BitLocker recovery keys
- [ ] Document what was changed
- [ ] Keep backup of configuration files

## Need More Help?

1. **Detailed Documentation**: See `AUTOMATION_GUIDE.md`
2. **Feature Overview**: See `README_AUTOMATION.md`
3. **Main Documentation**: See `README.md`
4. **Dism++ Official Docs**: https://www.chuyu.me
5. **Microsoft DISM Docs**: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism

## Tips and Tricks

### Tip 1: Test in VM First
Always test configurations in a virtual machine before applying to production systems.

### Tip 2: Keep Backups
Save all generated configuration files for reuse and troubleshooting.

### Tip 3: Document Changes
Use the scan feature before and after changes to document what was modified.

### Tip 4: Incremental Changes
Apply one configuration at a time to isolate any issues.

### Tip 5: Recovery Keys
Always back up BitLocker recovery keys to multiple secure locations.

### Tip 6: Network Drivers
When creating installation media, inject ethernet drivers to enable Windows Update during OOBE.

### Tip 7: Adaptive Profiles
Use adaptive configuration profiles to quickly replicate settings to similar systems.

### Tip 8: Regular Scans
Schedule regular system scans to track configuration drift.

## Next Steps

After completing quick start:
1. Read full documentation in `AUTOMATION_GUIDE.md`
2. Review your system scan results
3. Plan your configuration strategy
4. Test in non-production environment
5. Deploy to production systems

---

**Version**: 1.0  
**Last Updated**: 2025-10-11  
**For detailed documentation see**: [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md)
