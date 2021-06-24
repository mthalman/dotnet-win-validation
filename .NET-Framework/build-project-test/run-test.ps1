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
    $output = & ../../common/build-and-run-container.ps1 $WindowsTag "project\Dockerfile" "project\"
    if (-not $output.Contains("Hello World!")) {
        return 1
    }
}
finally {
    Pop-Location
}

return 0
