[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag
)

if (-not $WindowsTag.Contains("servercore")) {
    Write-Warning ".NET sample image doesn't exist for $WindowsTag."
    return -1
}

Push-Location $PSScriptRoot

try {
    $result = $(& ../../common/run-web-sample-test.ps1 -WindowsTag $WindowsTag -SampleRepo "mcr.microsoft.com/dotnet/framework/samples")
    return $result
}
finally {
    Pop-Location
}
