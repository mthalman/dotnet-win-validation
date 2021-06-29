[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $Tag
)

$containerName = $(New-Guid).Guid
$port = 8000

# Run the container as a daemon
$(docker run --rm --name $containerName -d -p ${port}:80 $Tag) | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw
}

# Send a request to test the app works
try {
    $response = Invoke-WebRequest -Uri "http://localhost:$port"
    $statusCode = $response.StatusCode

    if ($statusCode -ne 200) {
        Write-Host "Request failed with status code $statusCode"
        return 1
    }

    return 0
}
catch {
    Write-Host "Request failed: $_.Exception.Message"
    return 1
}
finally {
    docker stop $containerName
}
