<#
.SYNOPSIS
    This PowerShell script ensures that the LanMan authentication level is set to send NTLMv2 response only, and to refuse LM and NTLM.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-08-20
    Last Modified   : 2026-08-20
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000205

.TESTED ON
    Date(s) Tested  : 2026-08-20
    Tested By       : Sidi / sidi-o
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\WN11-SO-000205.ps1 
#>

# Remediation
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$ValueName    = "LmCompatibilityLevel"
$ValueData    = 5

# Ensure the registry path exists
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Configure NTLMv2 only
New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null

Write-Host "LmCompatibilityLevel configured to $ValueData."

# Verification
$value = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).LmCompatibilityLevel

if ($value -eq $ValueData) {
    Write-Host "PASS - LmCompatibilityLevel is configured to $ValueData." -ForegroundColor Green
}
else {
    Write-Host "FAIL - LmCompatibilityLevel is not configured to $ValueData." -ForegroundColor Red
}
