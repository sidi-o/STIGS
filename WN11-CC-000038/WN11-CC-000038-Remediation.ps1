.NOTES
    Author          : Sidi Ouattara
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-08-17
    Last Modified   : 2026-08-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000038

.TESTED ON
    Date(s) Tested  : 2026-08-17
    Tested By       : Sidi / sidi-o
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\SWN11-CC-000038.ps1 
#>

# Configure WDigest to not use plaintext credentials
$Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest'

# Create the registry key if needed
New-Item -Path $Path -Force | Out-Null

# Set UseLogonCredential to 0 (REG_DWORD)
New-ItemProperty -Path $Path -Name 'UseLogonCredential' `
    -PropertyType DWord -Value 0 -Force | Out-Null

# Verify the configuration
$Value = (Get-ItemProperty -Path $Path -Name 'UseLogonCredential').UseLogonCredential

if ($Value -eq 0) {
    Write-Host "WDigest UseLogonCredential successfully set to 0." -ForegroundColor Green
} else {
    Write-Error "Failed to configure WDigest UseLogonCredential."
}
