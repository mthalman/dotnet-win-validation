[cmdletbinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $WindowsTag
)

$scriptFiles = Get-ChildItem -Recurse -Filter run-test.ps1

$failed = 0
$passed = 0
$skipped = 0

foreach ($scriptFile in $scriptFiles) {

    $scriptPath = $scriptFile.FullName

    Write-Host
    Write-Host "============================="
    Write-Host -ForegroundColor Cyan "Executing $scriptPath"
    Write-Host "============================="

    try {
        $result = & $scriptPath $WindowsTag
    }
    catch {
        $result = 1
    }

    Write-Host
    switch ($result) {
        0 { $passed++; Write-Host -ForegroundColor Green "Test Passed" }
        1 { $failed++; Write-Error "Test Failed" }
        -1 { $skipped++; Write-Warning "Test Skipped" }
    }
}

Write-Host
Write-Host "============================="
Write-Host -ForegroundColor Cyan "Results"
Write-Host "============================="

Write-Host -ForegroundColor Green "Passed: $passed"
Write-Host -ForegroundColor Yellow "Skipped: $skipped"
Write-Host -ForegroundColor Red "Failed: $failed"
Write-Host

if ($failed -gt 0) {
    Write-Error "Test suite failed"
} else {
    Write-Host -ForegroundColor Green "Test suite passed"
}
