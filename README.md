# ICA Chat

IBM ICA（IBM Consulting Advantage）API を利用したチャットUIアプリケーションです。  
Quarkus + LangChain4j で構築されています。

## 構成

```
ブラウザ (http://localhost:8080)
    ↓
Quarkus サーバー (localhost:8080)
    ↓
ICA API (https://api.nextgen-beta.ica.ibm.com)
```

## 機能

- 複数の LLM モデル切替（GPT・Claude・Llama・Granite）
- 会話メモリ（直近3往復の文脈を保持）
- ストリーミング応答（1文字ずつリアルタイム表示）
- セッション管理（サーバー側でセッション発行・検証）
- エラーハンドリング・リトライ（Fault Tolerance）
- ブラウザから終了ボタンでサーバー停止

## セットアップ

### 1. APIキーの配置

```bash
echo "your-ica-api-key" > ica-api-key.txt
```

### 2. 起動

```bash
# macOS: ダブルクリックで起動
start.command

# または手動起動
export ICA_API_KEY=your-ica-api-key
cd ica-chat
java -jar target/quarkus-app/quarkus-run.jar
```

### 3. ブラウザでアクセス

```
http://localhost:8080
```

## ビルド

```bash
cd ica-chat
./mvnw package -DskipTests
```

## 技術スタック

| 項目 | 内容 |
|---|---|
| フレームワーク | Quarkus 3.15.5 (OSS LTS) |
| AI Integration | Quarkus LangChain4j 0.26.1 |
| LLM API | IBM ICA API (OpenAI互換) |
| メモリ | MessageWindowChatMemory (max 6 messages) |
| フロントエンド | HTML + CSS + Vanilla JS (SSE streaming) |

## 対応モデル

| モデル | ID |
|---|---|
| GPT-5.1 | `gpt-5.1-chat-gus` |
| GPT-4o | `gpt-4o` |
| Claude Sonnet 4.5 | `claude-sonnet-4-5` |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` |
| Claude Haiku 4.5 | `claude-haiku-4-5` |
| Claude Opus 4.7 | `claude-opus-4-7` |
| Llama4 Maverick | `meta-llama/llama-4-maverick-17b-128e-instruct-fp8` |
| Granite 4 Small | `ibm/granite-4-h-small` |

## 注意事項

- `ica-api-key.txt` は `.gitignore` で除外済み。絶対にコミットしないこと。
- サーバーは `@ApplicationScoped` でセッションを保持するため、再起動すると会話履歴はリセットされます。
