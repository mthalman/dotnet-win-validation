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
    $BuildContext,

    [Array]
    $Command
)

$tag = $(New-Guid).Guid
$(docker build -t $tag --build-arg WINDOWS_TAG=$WindowsTag -f $Dockerfile $BuildContext) | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw
}

try {
    $(docker run --rm $tag @Command) -join "`n" | Tee-Object -Variable output | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw
    }
}
finally {
    $(docker rmi $tag) | Out-Host
}

return $output
