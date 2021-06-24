[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag,

    [Parameter(Mandatory = $true)]
    [string]
    $SampleRepo
)

Push-Location $PSScriptRoot

try {
    if ($WindowsTag.Contains("nanoserver")) {
        $windowsVersion = "nanoserver"
    }
    elseif ($WindowsTag.Contains("servercore")) {
        $windowsVersion = "windowsservercore"
    }
    else {
        Write-Warning ".NET sample image doesn't exist for $WindowsTag."
        return -1
    }

    # Converts the value into the form of <server-type>-<version>
    $windowsVersion = "$windowsVersion-$($WindowsTag.Substring($WindowsTag.IndexOf(":") + 1))"

    $sampleTag = "${SampleRepo}:aspnetapp-$windowsVersion"
    $(docker pull $sampleTag 2>&1) -join "`n" | Tee-Object -Variable pullResult | Out-Host
    if ($LASTEXITCODE -ne 0) {
        if ($pullResult.Contains("Error response from daemon") -and $pullResult.Contains("is not found")) {
            Write-Warning ".NET sample image doesn't exist for $WindowsTag."
            return -1
        }
        else {
            throw
        }
    }

    $containerName = $(New-Guid).Guid
    $port = 8000

    # Run the container as a daemon
    $(docker run --rm --name $containerName -d -p ${port}:80 $sampleTag) | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw
    }

    # Send a request to test the app works
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$port"
        $statusCode = $response.StatusCode
    }
    catch {
        Write-Host "Request failed: $_.Exception.Message"
        return 1
    }
    finally {
        docker stop $containerName
    }

    if ($statusCode -ne 200) {
        Write-Host "Request failed with status code $statusCode"
        return 1
    }
}
finally {
    Pop-Location
}

return 0
