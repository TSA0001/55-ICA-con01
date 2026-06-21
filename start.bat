@echo off
chcp 65001 > nul
setlocal

set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%ica-chat"

:: APIキーをファイルから読み込み
if "%ICA_API_KEY%"=="" (
    set KEY_FILE=%SCRIPT_DIR%ica-api-key.txt
    if exist "%KEY_FILE%" (
        set /p ICA_API_KEY=<"%KEY_FILE%"
    ) else (
        echo ERROR: ica-api-key.txt が見つかりません。
        echo   %KEY_FILE% に APIキーを配置してください。
        pause
        exit /b 1
    )
)

:: 既存プロセスを終了（8080番ポートを使用しているプロセス）
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8080 "') do (
    echo 既存のプロセス(PID: %%a)を終了します...
    taskkill /f /pid %%a 2>nul
)
timeout /t 1 /nobreak > nul

echo ICA Chat サーバーを起動中...
echo ブラウザで http://localhost:8080 を開いてください
echo 停止するには このウィンドウを閉じてください
echo ------------------------------------

:: ブラウザを開く（2秒後）
start /b cmd /c "timeout /t 2 /nobreak > nul && start http://localhost:8080"

:: サーバー起動
java -jar target\quarkus-app\quarkus-run.jar

pause
