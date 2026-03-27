# TSVにINDEXカラムを追加するスクリプト
# 使い方: .\add_index.ps1 -InputFile customers.tsv [-OutputFile output.tsv]

param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

# 入力ファイルの存在確認
if (-not (Test-Path $InputFile)) {
    Write-Error "ファイルが見つかりません: $InputFile"
    exit 1
}

# 出力先フォルダが存在しない場合は作成
$outputDir = Split-Path $OutputFile -Parent
if ($outputDir -and -not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# TSV読み込み
$lines = [System.IO.File]::ReadAllLines($InputFile, [System.Text.Encoding]::UTF8)

if ($lines.Count -eq 0) {
    Write-Error "ファイルが空です: $InputFile"
    exit 1
}

$result = [System.Collections.Generic.List[string]]::new()

# ヘッダー行にINDEXを先頭に追加
$result.Add("INDEX`t" + $lines[0])

# データ行に連番を付与
for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -ne "") {
        $result.Add("$i`t" + $lines[$i])
    }
}

# 出力
$result | Set-Content $OutputFile -Encoding UTF8

# 出力成功を確認してから元ファイルを削除
if ($?) {
    if ($OutputFile -ne $InputFile) {
        Remove-Item $InputFile
    }
    Write-Host "完了: $OutputFile に書き出しました（データ行数: $($result.Count - 1)）"
} else {
    Write-Error "出力に失敗したため、元ファイルは削除しませんでした"
    exit 1
}
