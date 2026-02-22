$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    cmake -S . -B build
    cmake --build build --config Release --target vst3_harness

    $harnessExe = Get-ChildItem -Path build -Recurse -File -Filter "vst3_harness.exe" |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $harnessExe) {
        throw "Unable to locate vst3_harness.exe under build/."
    }

    $resolvedPath = $harnessExe.FullName
    Write-Host "Running harness: $resolvedPath"
    & $resolvedPath --help
}
finally {
    Pop-Location
}
