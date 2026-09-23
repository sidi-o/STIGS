#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script forces Advanced Audit Policy subcategory settings to override legacy audit policy categories.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com./sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000030

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-SO-000030.ps1
#>

\$RegistryPath  = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
\$ValueName     = "SCENoApplyLegacyAuditPolicy"
\$RequiredValue = 1

Write-Host "Configuring WN11-SO-000030..." -ForegroundColor Cyan

# Ensure the registry path exists
if (-not (Test-Path -Path \$RegistryPath)) {
    New-Item -Path \$RegistryPath -Force | Out-Null
}

# Remediation - Create or update the registry value
New-ItemProperty -Path \$RegistryPath -Name ValueName -PropertyType DWord -Value RequiredValue -Force | Out-Null

# Verification
CurrentValue = (Get-ItemProperty -Path RegistryPath -Name ValueName -ErrorAction SilentlyContinue).ValueName

Write-Host "`nCurrent configuration:" -ForegroundColor Cyan
Write-Host "$ValueName = $CurrentValue"

if ($CurrentValue -eq $RequiredValue) {
    Write-Host "`nPASS: WN11-SO-000030 is configured." -ForegroundColor Green
} else {
    Write-Error "FAIL: WN11-SO-000030 is not configured correctly."
    exit 1
}
