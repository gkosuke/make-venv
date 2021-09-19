#Requires -Version 7.2

# Settings =====================================================
$requirementsPath = 'requirements.txt'
$venvPath = '.venv'
# ==============================================================

# 関数: コマンドの存在確認
function cmdIsExists ($command) {
    Get-Command $command -errorAction SilentlyContinue
}

# Pythonランチャーの特定
if (cmdIsExists('py')) {
    $pythonPath = 'py'
}
elseif (cmdIsExists('python')) {
    $pythonPath = 'python'
}
# Windows環境ではpython3 -m venv .venv が動かなかった
else {
    Write-Error 'Pythonをインストールしてください。'
    exit
}

# Requirements.txtの存在確認
if (-not(Test-Path $requirementsPath)) {
    New-Item $requirementsPath > $null
    Write-Output "$requirementsPath を作成しました。"
    Write-Output '必要なライブラリを入力してください。'
    exit
}

# venvの再構築
Write-Output "$venvPath を再構築します。"
if (Test-Path $venvPath) {
    Remove-Item $venvPath -Recurse
}
Invoke-Expression "$pythonPath -m venv $venvPath"
Write-Output "$venvPath を再構築しました。"

# venvに入る
.".\$venvPath\Scripts\activate"
Write-Output 'venvに入りました。Pythonのバージョンとpipのバージョンは以下になります。'
python --version
pip --version

# pipのアップグレード
Write-Output 'pipをアップグレードします。'
python -m pip install --upgrade pip
Write-Output 'pipをアップグレードしました。'

# ライブラリのインストール
Write-Output 'ライブラリをインストールします。'
pip install -r $requirementsPath
Write-Output '以下のライブラリをインストールしました。'
pip freeze

deactivate
