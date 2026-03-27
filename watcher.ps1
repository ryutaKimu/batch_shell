# ファイル監視スクリプト
# 使い方: .\watcher.ps1

$inputDir  = Join-Path $PSScriptRoot "input"
$outputDir = Join-Path $PSScriptRoot "output"
$script    = Join-Path $PSScriptRoot "add_index.ps1"

Write-Host "監視開始: $inputDir"

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $inputDir
$watcher.Filter = "*.tsv"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher "Created" -Action {
    $inputFile  = $Event.SourceEventArgs.FullPath
    $dateFolder = Get-Date -Format "yyyy-MM-dd"
    $outputFile = Join-Path $using:outputDir "$dateFolder\customers_indexed.tsv"

    Write-Host "検知: $inputFile"
    & $using:script -InputFile $inputFile -OutputFile $outputFile
}

# 監視を継続
while ($true) { Start-Sleep 1 }
