#Requires -RunAsAdministrator

<#
.SYNOPSIS
    This PowerShell script ensures that the system is configured to audit Detailed Tracking - Process Creation successes.
    
.NOTES
    Author          : Sidi O
    LinkedIn        : linkedin.com/in/sidi-o
    GitHub          : github.com/sidi-o
    Date Created    : 2026-09-23
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000050

.TESTED ON
    Date(s) Tested  : 2026-09-23
    Tested By       : Sidi O
    Systems Tested  : Windows 11
    PowerShell Ver. : 5.1

.USAGE
    Example syntax:
    PS C:\> .\WN11-AU-000050.ps1
#>

# Remediation
auditpol.exe /set /subcategory:"Process Creation" /success:enable

# Verification
$audit = auditpol.exe /get /subcategory:"Process Creation"
if ($audit -match "Success" -or $audit -match "Succès") {
    Write-Host "PASS - Process Creation audit is configured to Success." -ForegroundColor Green
} else {
    Write-Host "FAIL - Process Creation audit is NOT configured to Success." -ForegroundColor Red
}
