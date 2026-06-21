#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ica-chat"

# 既存プロセスを終了
EXISTING=$(lsof -ti:8080 2>/dev/null || fuser 8080/tcp 2>/dev/null)
if [ -n "$EXISTING" ]; then
    echo "既存のプロセス(PID: $EXISTING)を終了します..."
    kill -9 "$EXISTING" 2>/dev/null
    sleep 1
fi

# APIキーをファイルから読み込んで環境変数にセット
if [ -z "$ICA_API_KEY" ]; then
    KEY_FILE="$SCRIPT_DIR/ica-api-key.txt"
    if [ -f "$KEY_FILE" ]; then
        export ICA_API_KEY=$(cat "$KEY_FILE" | tr -d '[:space:]')
    else
        echo "ERROR: ica-api-key.txt が見つかりません。"
        echo "  $KEY_FILE に APIキーを配置してください。"
        exit 1
    fi
fi

echo "ICA Chat サーバーを起動中..."
echo "ブラウザで http://localhost:8080 を開いてください"
echo "停止するには Ctrl+C を押してください"
echo "------------------------------------"

# ブラウザを開く（Linux 各種デスクトップ環境対応）
(sleep 2 && xdg-open http://localhost:8080 2>/dev/null || \
           gnome-open http://localhost:8080 2>/dev/null || \
           echo "ブラウザで http://localhost:8080 を開いてください") &

# Native Image があれば使う、なければ JVM で起動
if [ -f "target/ica-chat-runner" ]; then
    echo "起動モード: Native Image（高速）"
    ./target/ica-chat-runner
else
    echo "起動モード: JVM"
    java -jar target/quarkus-app/quarkus-run.jar
fi
