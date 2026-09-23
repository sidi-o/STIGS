

#Remediation
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$ValueName    = "LmCompatibilityLevel"
$ValueData    = 5

# Ensure the registry path exists
if (-not (Test-Path -Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Configure NTLMv2 only
New-ItemProperty `
    -Path $RegistryPath `
    -Name $ValueName `
    -PropertyType DWord `
    -Value $ValueData `
    -Force | Out-Null

Write-Host "LmCompatibilityLevel configured to $ValueData."



#Verificaiton
$value = (Get-ItemProperty `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" `
    -Name "LmCompatibilityLevel" `
    -ErrorAction SilentlyContinue).LmCompatibilityLevel

if ($value -eq 5) {
    Write-Host "PASS - LmCompatibilityLevel is configured to 5." -ForegroundColor Green
}
else {
    Write-Host "FAIL - LmCompatibilityLevel is not configured to 5." -ForegroundColor Red
}
