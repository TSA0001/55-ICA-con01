#!/bin/bash
# ============================================
# ICA Chat ビルドスクリプト (macOS)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ica-chat"

echo "======================================"
echo " ICA Chat ビルド (macOS)"
echo "======================================"
echo ""
echo "ビルドモードを選択してください:"
echo "  1) JVM モード（標準・GraalVM不要）"
echo "  2) Native Image モード（高速起動・GraalVM必要）"
echo ""
read -p "選択 [1/2] (デフォルト: 1): " choice
choice=${choice:-1}

if [ "$choice" = "2" ]; then
    # Native Image ビルド前提条件チェック
    if ! which native-image > /dev/null 2>&1; then
        echo ""
        echo "ERROR: native-image コマンドが見つかりません。"
        echo ""
        echo "GraalVM のインストール手順:"
        echo "  1. https://www.graalvm.org/downloads/ から GraalVM をダウンロード"
        echo "  または Homebrew でインストール:"
        echo "  brew install --cask graalvm-jdk"
        echo "  export JAVA_HOME=\$(/usr/libexec/java_home -v 21)"
        echo "  gu install native-image"
        echo ""
        exit 1
    fi
    echo ""
    echo "Native Image ビルドを開始します（5〜15分かかります）..."
    ./mvnw package -Pnative -DskipTests
    if [ $? -eq 0 ]; then
        echo ""
        echo "======================================"
        echo " ビルド成功！"
        echo " バイナリ: ica-chat/target/ica-chat-runner"
        echo " 起動: ./start.command"
        echo "======================================"
    fi
else
    echo ""
    echo "JVM モードでビルドします..."
    ./mvnw package -DskipTests
    if [ $? -eq 0 ]; then
        echo ""
        echo "======================================"
        echo " ビルド成功！"
        echo " JAR: ica-chat/target/quarkus-app/quarkus-run.jar"
        echo " 起動: ./start.command"
        echo "======================================"
    fi
fi
