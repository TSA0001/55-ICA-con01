#!/bin/bash
# ============================================
# ICA Chat ビルドスクリプト (Linux)
# ============================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/ica-chat"

echo "======================================"
echo " ICA Chat ビルド (Linux / JVM モード)"
echo "======================================"
echo ""

# Java チェック
if ! which java > /dev/null 2>&1; then
    echo "ERROR: Java が見つかりません。"
    echo ""
    echo "Java のインストール手順:"
    echo "  Ubuntu/Debian: sudo apt install openjdk-21-jdk"
    echo "  RHEL/CentOS:   sudo dnf install java-21-openjdk"
    echo ""
    exit 1
fi

echo "Java バージョン: $(java -version 2>&1 | head -1)"
echo ""
echo "JVM モードでビルドします..."
./mvnw package -DskipTests

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo " ビルド成功！"
    echo " JAR: ica-chat/target/quarkus-app/quarkus-run.jar"
    echo " 起動: bash start.sh"
    echo "======================================"
fi
