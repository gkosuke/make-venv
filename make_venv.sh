#!/usr/bin/env sh
# shellcheck disable=SC1091

# Settings =====================================================
readonly REQUIREMENTS_PATH="requirements.txt"
readonly VENV_PATH=".venv"
# ==============================================================

# 関数: コマンドの存在確認
cmd_is_exists() {
    type "$1" >/dev/null 2>&1
}

# Pythonランチャーの特定
if cmd_is_exists python3; then
    readonly PYTHON_PATH="python3"
elif cmd_is_exists python; then
    readonly PYTHON_PATH="python"
else
    echo "Pythonをインストールしてください。"
    exit 1
fi
echo "Pythonランチャー: $PYTHON_PATH"

# requirements.txtの存在確認
if ! test -f $REQUIREMENTS_PATH; then
    touch $REQUIREMENTS_PATH
    echo "$REQUIREMENTS_PATHを作成しました。"
    echo "必要なライブラリを入力してください。"
    exit 1
fi

# venvの再構築
echo "$VENV_PATHを再構築します。"
if ! test -d $VENV_PATH; then
    rm -rf $VENV_PATH
fi
$PYTHON_PATH -m venv "$VENV_PATH"
echo "$VENV_PATHを再構築しました。"

# venvに入る
. "$VENV_PATH/bin/activate"
echo "venvに入りました。Pythonのバージョンとpipのバージョンは以下になります。"
python --version
pip --version

# pipのアップグレード
echo "pipをアップグレードします。"
python -m pip install --upgrade pip
echo "pipをアップグレードしました。"

# ライブラリのインストール
echo "ライブラリをインストールします。"
pip install -r $REQUIREMENTS_PATH
echo "以下のライブラリをインストールしました。"
pip freeze

deactivate
