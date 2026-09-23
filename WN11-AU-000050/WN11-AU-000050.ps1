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


# WN11-AU-000050
# Audit Detailed Tracking - Process Creation successes

$AuditPol = Join-Path $env:SystemRoot 'System32\auditpol.exe'

if (-not (Test-Path -LiteralPath $AuditPol)) {
    Write-Error "AuditPol was not found: $AuditPol"
    exit 1
}

Write-Host "Enabling Process Creation Success auditing..." -ForegroundColor Cyan

& $AuditPol /set /subcategory:"Process Creation" /success:enable

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to enable Process Creation Success auditing."
    exit $LASTEXITCODE
}

Write-Host "Process Creation auditing configured." -ForegroundColor Green

Write-Host "`nVerifying configuration..." -ForegroundColor Cyan

$Result = & $AuditPol /get /subcategory:"Process Creation"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Unable to verify Process Creation audit configuration."
    exit $LASTEXITCODE
}

$Result | ForEach-Object {
    Write-Host $_
}

Write-Host "`nPASS: Process Creation Success auditing is enabled." -ForegroundColor Green

Write-Host "`nNote: WN11-SO-000030 must also be compliant for Advanced Audit Policy subcategories to override legacy audit policy categories." -ForegroundColor Yellow
