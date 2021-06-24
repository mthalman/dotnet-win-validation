[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag
)

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
