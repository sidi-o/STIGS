#requires -RunAsAdministrator


<#
.SYNOPSIS
    This PowerShell script configures the Windows SMB client to always perform packet signing, protecting communications from tampering.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000100

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-SO-000100.ps1
#>


$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters'
$ValueName    = 'RequireSecuritySignature'
$ValueData    = 1

try {
    # Ensure the registry key exists
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Enable SMB client packet signing (always)
    New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null

    # Verify configuration
    $Result = Get-ItemPropertyValue -Path $RegistryPath -Name $ValueName -ErrorAction Stop

    if ($Result -eq 1) {
        Write-Output 'SUCCESS: SMB client signing is configured as Required.'
        exit 0
    }
    else {
        Write-Error "FAILED: RequireSecuritySignature is set to $Result instead of 1."
        exit 1
    }
}
catch {
    Write-Error "FAILED: Unable to configure SMB client signing. $($_.Exception.Message)"
    exit 1
}
