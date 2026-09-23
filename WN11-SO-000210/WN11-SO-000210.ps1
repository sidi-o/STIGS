#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script configures the required LDAP client signing level to enforce data integrity and prevent man-in-the-middle exploits.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000210

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-SO-000210.ps1
#>

#requires -RunAsAdministrator

$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LDAP'
$ValueName    = 'LDAPClientIntegrity'
$ValueData    = 1

try {
    # Ensure the registry key exists
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set LDAP client signing requirement to Negotiate signing
    New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null

    # Verify the resulting configuration
    $Result = Get-ItemPropertyValue -Path $RegistryPath  -Name $ValueName  -ErrorAction Stop

    if ($Result -eq $ValueData) {
        Write-Output "SUCCESS: LDAPClientIntegrity is configured to $Result (Negotiate signing)."
        exit 0
    }
    else {
        Write-Error "FAILED: LDAPClientIntegrity is configured to $Result instead of $ValueData."
        exit 1
    }
}
catch {
    Write-Error "FAILED: Unable to configure LDAP client signing requirements. $($_.Exception.Message)"
    exit 1
}
