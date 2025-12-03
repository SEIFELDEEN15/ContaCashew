$file = Join-Path $env:LOCALAPPDATA 'Pub\Cache\hosted\pub.dev\flutter_charset_detector_android-1.0.0\android\build.gradle'
Get-Content $file | Select-Object -First 50
