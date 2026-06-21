@echo off
chcp 65001 > nul
:: ============================================
:: ICA Chat ビルドスクリプト (Windows)
:: ============================================
setlocal

set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%ica-chat"

echo ======================================
echo  ICA Chat ビルド (Windows / JVM モード)
echo ======================================
echo.

:: Java チェック
java -version > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java が見つかりません。
    echo.
    echo Java のインストール手順:
    echo   https://adoptium.net/ から Eclipse Temurin 21 をダウンロードしてインストール
    echo   インストール後、このスクリプトを再実行してください。
    echo.
    pause
    exit /b 1
)

echo JVM モードでビルドします...
echo.
call mvnw.cmd package -DskipTests

if %errorlevel% equ 0 (
    echo.
    echo ======================================
    echo  ビルド成功！
    echo  JAR: ica-chat\target\quarkus-app\quarkus-run.jar
    echo  起動: start.bat をダブルクリック
    echo ======================================
) else (
    echo.
    echo ERROR: ビルドに失敗しました。
    echo 上記のエラーメッセージを確認してください。
)

pause
