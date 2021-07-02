[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag,

    [Parameter(Mandatory = $true)]
    [string]
    $Dockerfile,

    [Parameter(Mandatory = $true)]
    [string]
    $BuildContext
)

$tag = $(New-Guid).Guid
$(docker build -t $tag --build-arg WINDOWS_TAG=$WindowsTag -f $Dockerfile $BuildContext) | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw
}

try {
    Push-Location $PSScriptRoot
    try {
        $result = & ./test-web-container.ps1 $tag
        return $result
    }
    finally {
        Pop-Location
    }
}
finally {
    $(docker rmi $tag) | Out-Host
}



