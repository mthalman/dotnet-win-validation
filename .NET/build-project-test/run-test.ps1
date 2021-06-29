[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag
)

Push-Location $PSScriptRoot

try {
    $result = & ../../common/build-and-run-web-container.ps1 $WindowsTag "project\Dockerfile" "project\"
    return $result
}
finally {
    Pop-Location
}
