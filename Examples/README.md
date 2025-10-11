# Dism++ Automation Examples

This directory contains example configuration files that can be used with the Dism++ Automation CLI.

## Files

### example_unattend_oobe_skip.xml
Complete OOBE bypass configuration for Windows installation.

**Usage**:
- For USB installation: Copy to USB root as `autounattend.xml`
- For WIM: Inject to `C:\Mount\Windows\Panther\unattend.xml`

### example_hardware_bypass.reg
Registry configuration to bypass Windows 11 hardware requirements.

**Usage**:
- Double-click to apply to current system before upgrade
- For WIM: Import to mounted image registry
- For USB: Include on installation media

**Useful for**:
- Intel 7700K and other 7th Gen processors
- Systems without TPM 2.0
- Systems without Secure Boot

### example_telemetry_hosts.txt
List of telemetry domains to block via hosts file.

**Usage**:
1. Open `C:\Windows\System32\drivers\etc\hosts` as Administrator
2. Append contents of this file
3. Save and restart

**Effect**:
- Blocks Microsoft telemetry at DNS level
- Enhanced privacy
- Reduced network traffic

### example_bulk_users.csv
Template for bulk user account creation.

**Usage**:
1. Edit CSV with desired users
2. Run DismAutomation.bat → [7] → [1]
3. Users created automatically

**Format**:
```csv
username,password,fullname,description
```

### example_security_hardening.inf
Security policy template based on CIS Benchmarks.

**Usage**:
```batch
secedit /configure /db secedit.sdb /cfg example_security_hardening.inf
```

**Includes**:
- Strong password policies
- Account lockout policies
- Audit policies
- User rights assignments
- Network security settings

## Using Examples

### Example 1: Privacy-Focused Installation

```batch
# Step 1: Apply hardware bypass (if needed)
reg import example_hardware_bypass.reg

# Step 2: Copy OOBE skip to installation media
copy example_unattend_oobe_skip.xml E:\autounattend.xml

# Step 3: Install Windows

# Step 4: After installation, block telemetry
type example_telemetry_hosts.txt >> C:\Windows\System32\drivers\etc\hosts
```

### Example 2: Secure Enterprise Deployment

```batch
# Step 1: Apply security hardening
secedit /configure /db secedit.sdb /cfg example_security_hardening.inf

# Step 2: Create user accounts
# Edit example_bulk_users.csv first
DismAutomation.bat -> [7] -> [1]

# Step 3: Enable BitLocker
DismAutomation.bat -> [12] -> [3]
```

### Example 3: Custom Windows Image

```batch
# Step 1: Mount image
dism /Mount-Image /ImageFile:install.wim /Index:1 /MountDir:C:\Mount

# Step 2: Inject OOBE bypass
copy example_unattend_oobe_skip.xml C:\Mount\Windows\Panther\unattend.xml

# Step 3: Inject hardware bypass
reg load HKLM\TempHive C:\Mount\Windows\System32\config\SYSTEM
reg import example_hardware_bypass.reg
reg unload HKLM\TempHive

# Step 4: Commit changes
dism /Unmount-Image /MountDir:C:\Mount /Commit
```

## Customization

All example files can be customized:

- **Passwords**: Change to secure passwords
- **Usernames**: Modify for your organization
- **Domains**: Add/remove telemetry domains
- **Policies**: Adjust security settings as needed
- **OOBE settings**: Enable/disable specific screens

## Important Notes

⚠️ **Warnings**:
- Test all configurations in non-production environment first
- Backup system before applying changes
- Understand implications of each setting
- Some configurations may affect Windows features
- Hardware bypasses may reduce security

✅ **Best Practices**:
- Review and customize examples before use
- Document any modifications
- Keep backup copies of configurations
- Test thoroughly before production deployment
- Maintain configuration version control

## More Information

For detailed documentation, see:
- [AUTOMATION_GUIDE.md](../AUTOMATION_GUIDE.md) - Complete documentation
- [QUICKSTART.md](../QUICKSTART.md) - Quick start guide
- [README_AUTOMATION.md](../README_AUTOMATION.md) - Feature overview

## Support

For issues or questions:
1. Check documentation files
2. Review example configurations
3. Consult Dism++ official documentation
4. Report issues on GitHub repository
