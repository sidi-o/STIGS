#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script disables insecure guest logons to SMB servers to prevent unauthenticated access to shared network folders.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000040

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-CC-000040.ps1
#>


$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation'
$ValueName    = 'AllowInsecureGuestAuth'
$ValueData    = 0

try {
    # Ensure the policy registry key exists
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Disable insecure SMB guest logons
    New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null

    # Verify the configuration
    $Result = Get-ItemPropertyValue -Path $RegistryPath -Name $ValueName -ErrorAction Stop

    if ($Result -eq 0) {
        Write-Output 'SUCCESS: Insecure SMB guest logons are disabled.'
        exit 0
    }
    else {
        Write-Error "FAILED: AllowInsecureGuestAuth is set to $Result instead of 0."
        exit 1
    }
}
catch {
    Write-Error "FAILED: Unable to configure SMB guest logon policy. $($_.Exception.Message)"
    exit 1
}
