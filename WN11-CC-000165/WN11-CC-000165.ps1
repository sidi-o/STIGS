#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script restricts unauthenticated Remote Procedure Call (RPC) clients from connecting to the local RPC server to prevent anonymous exploits.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000165

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-CC-000165.ps1
#>


$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc'
$ValueName    = 'RestrictRemoteClients'
$ValueData    = 1

try {
    # Ensure the policy registry key exists
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Restrict unauthenticated RPC clients
    New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null

    # Verify the configuration
    $Result = Get-ItemPropertyValue -Path $RegistryPath -Name $ValueName -ErrorAction Stop

    if ($Result -eq 1) {
        Write-Output 'SUCCESS: Unauthenticated RPC clients are restricted to authenticated clients.'
        exit 0
    }
    else {
        Write-Error "FAILED: RestrictRemoteClients is set to $Result instead of 1."
        exit 1
    }
}
catch {
    Write-Error "FAILED: Unable to configure RPC client restrictions. $($_.Exception.Message)"
    exit 1
}
