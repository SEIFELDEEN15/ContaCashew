param()

# Questo script applica fix di compatibilità al pacchetto flutter_charset_detector_android
# 1. Aggiunge la direttiva "namespace" al file build.gradle
# 2. Rimuove l'attributo "package" dal file AndroidManifest.xml

$packagePath = Join-Path $env:LOCALAPPDATA 'Pub\Cache\hosted\pub.dev\flutter_charset_detector_android-1.0.0\android'
$buildGradlePath = Join-Path $packagePath 'build.gradle'
$manifestPath = Join-Path $packagePath 'src\main\AndroidManifest.xml'
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Fix 1: build.gradle - aggiunge namespace e aggiorna compileSdkVersion
Write-Output "Controllo build.gradle: $buildGradlePath"

if (-not (Test-Path $buildGradlePath)) {
    Write-Error "File non trovato: $buildGradlePath"
    exit 1
}

$bak = "$buildGradlePath.bak"
Copy-Item -Path $buildGradlePath -Destination $bak -Force
Write-Output "Backup creato: $bak"

$content = Get-Content -Path $buildGradlePath -Raw -ErrorAction Stop
$modified = $false

if ($content -notmatch '(?m)^\s*namespace\s+[''"]') {
    # Inserisce la riga namespace subito dopo la dichiarazione 'android {'
    $content = $content -replace '(android\s*\{)', "`$1`n    namespace 'com.github.flutter_charset_detector_android'"

    if ($content -match '(android\s*\{)') {
        Write-Output "Aggiunta direttiva 'namespace' in build.gradle"
        $modified = $true
    } else {
        Write-Error "Non sono riuscito a inserire il namespace (pattern non trovato). Controlla manualmente: $buildGradlePath"
        exit 2
    }
} else {
    Write-Output "La proprietà 'namespace' è già presente in build.gradle"
}

# Aggiorna compileSdkVersion a 36 per compatibilità con l'app principale
if ($content -match 'compileSdkVersion\s+\d+') {
    $content = $content -replace 'compileSdkVersion\s+\d+', 'compileSdkVersion 36'
    Write-Output "Aggiornato compileSdkVersion a 36"
    $modified = $true
} else {
    Write-Output "compileSdkVersion non trovato o già aggiornato"
}

if ($modified) {
    [System.IO.File]::WriteAllText($buildGradlePath, $content, $utf8NoBom)
}

# Fix 2: AndroidManifest.xml - rimuove package
Write-Output "`nControllo AndroidManifest.xml: $manifestPath"

if (-not (Test-Path $manifestPath)) {
    Write-Warning "File non trovato: $manifestPath"
} else {
    $manifestBak = "$manifestPath.bak"
    Copy-Item -Path $manifestPath -Destination $manifestBak -Force
    Write-Output "Backup creato: $manifestBak"

    $manifestContent = Get-Content -Path $manifestPath -Raw -ErrorAction Stop

    if ($manifestContent -match 'package\s*=\s*["''][^"'']+["'']') {
        # Rimuove l'attributo package dal tag manifest
        $newManifestContent = $manifestContent -replace '\s*package\s*=\s*["''][^"'']+["'']', ''

        [System.IO.File]::WriteAllText($manifestPath, $newManifestContent, $utf8NoBom)
        Write-Output "Rimosso attributo 'package' da AndroidManifest.xml"
        $modified = $true
    } else {
        Write-Output "L'attributo 'package' non è presente in AndroidManifest.xml"
    }
}

if ($modified) {
    Write-Output "`nPatch completato con successo!"
} else {
    Write-Output "`nNessuna modifica necessaria."
}
