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

    $result = & ./test-web-container.ps1 $sampleTag
    return $result
}
finally {
    Pop-Location
}
