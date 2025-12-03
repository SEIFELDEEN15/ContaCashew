param()

$buildGradlePath = Join-Path $env:LOCALAPPDATA 'Pub\Cache\hosted\pub.dev\flutter_charset_detector_android-1.0.0\android\build.gradle'

Write-Output "Removing BOM from: $buildGradlePath"

$content = Get-Content -Path $buildGradlePath -Raw
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($buildGradlePath, $content, $utf8NoBom)

Write-Output "Done! File re-saved without BOM."
