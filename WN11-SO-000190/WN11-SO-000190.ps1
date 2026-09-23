#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script configures Kerberos encryption types to prevent the use of legacy and insecure DES and RC4 encryption suites.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000190

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-SO-000190.ps1
#>


# Requirement:
# Disable insecure DES and RC4 Kerberos encryption types.
#
# Required registry configuration:
# HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters
# SupportedEncryptionTypes = 0x7ffffff8 (2147483640)
#
# Allowed encryption types:
# - AES128_HMAC_SHA1
# - AES256_HMAC_SHA1
# - Future encryption types

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
$ValueName = 'SupportedEncryptionTypes'
$RequiredValue = [uint32]0x7FFFFFF8

Write-Host "Configuring WN11-SO-000190..." -ForegroundColor Cyan

# Create the registry key if it does not exist
if (-not (Test-Path -LiteralPath $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Configure the required REG_DWORD value
New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $RequiredValue -Force | Out-Null

# Verify configuration
$CurrentValue = (Get-ItemProperty -Path $RegistryPath  -Name $ValueName).$ValueName

Write-Host ""
Write-Host "Configured value:" -ForegroundColor Cyan
Write-Host "Path : $RegistryPath"
Write-Host "Name : $ValueName"
Write-Host "Value: $CurrentValue"
Write-Host "Hex  : 0x$('{0:X8}' -f $CurrentValue)"

if ([uint32]$CurrentValue -eq $RequiredValue) {
    Write-Host ""
    Write-Host "PASS: WN11-SO-000190 is configured correctly."  -ForegroundColor Green
}
else {
    Write-Error "FAIL: SupportedEncryptionTypes is not configured correctly."
    exit 1
}
