import json, urllib.request, sys

key = open('ica-api-key-claude.txt', encoding='utf-8').read().strip()

payload = {
    'model': 'claude-sonnet-4-5',
    'messages': [
        {'role': 'user', 'content': 'こんにちは！一言で自己紹介してください。それと 17×23 はいくつ？理由も短く。'}
    ],
    'stream': False
}

req = urllib.request.Request(
    'https://api.nextgen-beta.ica.ibm.com/ica/v1/chat-models/chat/completions',
    data=json.dumps(payload).encode('utf-8'),
    method='POST',
    headers={
        'Authorization': 'Bearer ' + key,
        'Content-Type': 'application/json',
        'User-Agent': 'curl/8.4.0'
    }
)

sys.stdout.reconfigure(encoding='utf-8')

with urllib.request.urlopen(req, timeout=120) as r:
    d = json.loads(r.read().decode('utf-8'))

print(d['choices'][0]['message']['content'])
print('---usage---', d.get('usage'))
