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
    & ../../common/build-and-run-container.ps1 $WindowsTag 'project\Dockerfile' 'project\' @('cmd', '/c', '"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngen display"') | Out-Host
}
finally {
    Pop-Location
}

return 0
