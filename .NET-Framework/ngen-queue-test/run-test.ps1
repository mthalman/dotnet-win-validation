[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag
)

if ($WindowsTag.Contains("nanoserver")) {
    Write-Warning ".NET Framework is not supported on Nano Server."
    return -1
}

Push-Location $PSScriptRoot

try {
    # Verify that there are no assemblies queued for ngen

    $(docker run --rm $WindowsTag cmd /c "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngen display") -join "`n" | Tee-Object -Variable output | Out-Host
    if ($LASTEXITCODE -ne 0 -or $output.Contains("(StatusPending)")) {
        throw
    }

    $(docker run --rm $WindowsTag cmd /c "C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen display") -join "`n" | Tee-Object -Variable output | Out-Host

    if ($LASTEXITCODE -ne 0 -or $output.Contains("(StatusPending)")) {
        throw
    }
}
finally {
    Pop-Location
}

return 0
