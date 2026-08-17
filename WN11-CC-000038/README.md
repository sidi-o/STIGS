

WN11-CC-000038 — WDigest Authentication
Overview

This case study documents the analysis, manual remediation, PowerShell implementation, and validation of Windows 11 STIG WN11-CC-000038.

Field	Value
STIG ID	WN11-CC-000038
SRG	SRG-OS-000095-GPOS-00049
Severity	CAT II / Medium
CCI	CCI-000381
Vulnerability ID	V-253358
Platform	Windows 11
Remediation	PowerShell / Registry
Validation	Tenable
Version	1.0
Tested	2026-08-17
Security Requirement

WDigest Authentication must be disabled.

When WDigest Authentication is enabled, plaintext credentials may be exposed in memory. Windows 11 disables this behavior by default, and this STIG requires the configuration to remain enforced.

The required registry configuration is:

Setting	Required Configuration
Registry Hive	HKEY_LOCAL_MACHINE
Registry Path	SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest
Value Name	UseLogonCredential
Type	REG_DWORD
Value	0
1. Initial Assessment

The Windows 11 VM was scanned using the applicable Windows 11 STIG Audit Policy.

The selected finding was:

WN11-CC-000038

Initial result:

FAIL

2. STIG Analysis

The STIG remediation guidance references the following Group Policy setting:

Computer Configuration
└── Administrative Templates
    └── MS Security Guide
        └── WDigest Authentication
            └── Disabled


The requirement was reviewed using STIG Viewer to identify the required security configuration and remediation procedure.

3. MS Security Guide Investigation

During the manual remediation process, the MS Security Guide administrative template was not available in the local Group Policy Editor.

The STIG remediation guidance requires the custom SecGuide administrative templates supplied with the STIG package.

Required files:

SecGuide.admx
SecGuide.adml


Installation paths:

SecGuide.admx
→ C:\Windows\PolicyDefinitions\

SecGuide.adml
→ C:\Windows\PolicyDefinitions\en-US\


The required STIG GPO package was obtained to identify and install the missing administrative templates.

After installation, the MS Security Guide policies became available in Group Policy Editor.

4. Manual Remediation

The WDigest Authentication policy was configured through Group Policy:

Computer Configuration
→ Administrative Templates
→ MS Security Guide
→ WDigest Authentication
→ Disabled


The Windows 11 VM was then rescanned.

Result:

PASS

5. Reversion Test

To verify that the configuration directly affected the STIG check, the manual remediation was reverted.

The system was rescanned after reverting the configuration.

Result:

FAIL

This confirmed that the security configuration directly affected the STIG finding.

6. PowerShell Remediation

The required configuration was then implemented using PowerShell.

PowerShell was selected to provide a repeatable and automatable remediation method without requiring the custom SecGuide administrative templates.

The script configures:

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest

UseLogonCredential = 0

Script

See Remediation.ps1.

The script:

Creates the WDigest registry key if required.
Creates or updates UseLogonCredential.
Configures it as a REG_DWORD.
Sets the value to 0.
Verifies the resulting configuration.

7. Local Verification

After executing the PowerShell remediation, the registry configuration was verified locally.

Get-ItemProperty `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest' `
    -Name 'UseLogonCredential'


Expected result:

UseLogonCredential : 0


This corresponds to:

REG_DWORD
0x00000000 (0)

8. Tenable Validation

After the PowerShell remediation was applied and locally verified, the Windows 11 VM was rescanned using Tenable.

Final result:

PASS

The Tenable result confirmed that WN11-CC-000038 was successfully remediated.

9. Remediation Workflow
STIG Audit
    ↓
WN11-CC-000038 identified
    ↓
Initial FAIL
    ↓
STIG analysis using STIG Viewer
    ↓
MS Security Guide not available
    ↓
STIG GPO / SecGuide templates identified
    ↓
Manual GPO remediation
    ↓
PASS
    ↓
Manual remediation reverted
    ↓
FAIL
    ↓
PowerShell remediation developed
    ↓
Local registry verification
    ↓
Tenable scan
    ↓
PASS

10. Testing

Operating System: Windows 11
PowerShell: Windows PowerShell 5.1
Test Date: 2026-08-17
Validation Tool: Tenable
Final Result: PASS

11. Security Considerations

This remediation modifies a security-related registry configuration under HKEY_LOCAL_MACHINE.

The script should be tested in a controlled environment before deployment to production systems.

Always verify the applicable STIG version and organizational security requirements before deployment.

References
DISA Windows 11 STIG
STIG Viewer
Windows 11 Group Policy
Windows Registry
Tenable
