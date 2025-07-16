from webbrowser import get
from flask import Flask, request
import firebase_admin
from firebase_admin import credentials, firestore
import datetime
from datetime import timezone

app = Flask(__name__)

# Firebase yapılandırması
cred = credentials.Certificate('firebase_key.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

VERIFY_TOKEN = 'my_secret_token'

@app.route('/webhook', methods=['GET', 'POST'])
def webhook():
    if request.method == 'GET':
        verify_token = request.args.get('hub.verify_token')
        challenge = request.args.get('hub.challenge')
        if verify_token == VERIFY_TOKEN and challenge:
            return str(challenge), 200
        return "Doğrulama başarısız.", 403

    if request.method == 'POST':
        data = request.get_json()
        print("POST İsteği Geldi:", data)

        try:
            entry = data.get('entry', [])[0]

            # Yorum (comment) varsa
            if 'changes' in entry:
                change = entry['changes'][0]['value']
                sender_username = change['from'].get('username', 'unknown')
                sender_id = change['from'].get('id', 'unknown')
                post_id = change.get('media', {}).get('id', 'unknown')
                text = change.get('text', '')
                unix_timestamp = change.get('timestamp', int(datetime.datetime.now().timestamp()))
                timestamp = datetime.datetime.fromtimestamp(unix_timestamp, tz=timezone.utc)
                object_type = data.get('object', 'unknown')


                db.collection('instagram_messages').add({
                    'type': 'comment',
                    'sender': sender_username,
                    'sender_id': sender_id,
                    'post_id': post_id,
                    'text': text,
                    'timestamp': timestamp,
                    'object': object_type 
                })
                print("Yorum verisi Firestore'a yazıldı.")

            # DM mesajı varsa
            elif 'messaging' in entry:
                messaging = entry['messaging'][0]
                sender_id = messaging['sender'].get('id', 'unknown')
                text = messaging.get('message', {}).get('text', '')
                # timestamp genelde milisaniye cinsinden geliyor, saniyeye çeviriyoruz
                unix_timestamp = messaging.get('timestamp', int(datetime.datetime.now().timestamp() * 1000))
                timestamp = datetime.datetime.fromtimestamp(unix_timestamp / 1000, tz=timezone.utc)
                object_type = data.get('object', 'unknown')

                db.collection('instagram_messages').add({
                    'type': 'dm',
                    'sender': sender_id,
                    'text': text,
                    'timestamp': timestamp,
                    'object' : object_type 
                })
                print("DM verisi Firestore'a yazıldı.")

            else:
                print("Webhook verisi tanımlanamayan yapı içeriyor.")

        except Exception as e:
            print("Firestore hatası:", e)

        return "OK", 200

if __name__ == '__main__':
    app.run(port=5000, debug=True)
