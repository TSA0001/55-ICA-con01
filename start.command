#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ica-chat"

# 既存プロセスを終了
EXISTING=$(lsof -ti:8080 2>/dev/null)
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
echo "停止するには Ctrl+C を押してください"
echo "------------------------------------"

# Native Image があれば使う、なければ JVM で起動
if [ -f "target/ica-chat-runner" ]; then
    echo "起動モード: Native Image（高速）"
    ./target/ica-chat-runner &
else
    echo "起動モード: JVM"
    java -jar target/quarkus-app/quarkus-run.jar &
fi
SERVER_PID=$!

# 起動待ち
sleep 2

# ブラウザを開く
open http://localhost:8080

# Ctrl+C で終了できるよう待機
trap "echo ''; echo 'サーバーを停止します...'; kill $SERVER_PID 2>/dev/null; exit 0" INT TERM
wait $SERVER_PID
