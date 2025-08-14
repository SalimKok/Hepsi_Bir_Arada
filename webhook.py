# webhook.py
from flask import Blueprint, request
import firebase_admin
from firebase_admin import credentials, firestore
import datetime
from datetime import timezone
from gemini_service import categorize
from gemini_service import suggested_reply as reply
from oto_request import send_dm_reply, reply_to_comment
from categories import get_categories_internal
import os

webhook_bp = Blueprint('webhook', __name__)
IG_ID = os.getenv('INSTAGRAM_IG_ID') 
db = firestore.client()
VERIFY_TOKEN = 'my_token'
user_id='mh5GLH4pHUV8GeiqqJOduMw46Jt2'


@webhook_bp.route('/webhook', methods=['GET', 'POST'])
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

        selected_categories = get_categories_internal(user_id)
        print("Kategoriler:", selected_categories)

        try:
            entry = data.get('entry', [])[0]

            # Yorum (comment) varsa
            if 'changes' in entry:
                change = entry['changes'][0]['value']
                sender_username = change['from'].get('username', 'unknown')
                sender_id = change['from'].get('id', 'unknown')
                if sender_id == IG_ID:
                    print("⏭️ Kendi bot mesaji tespit edildi, işlenmedi.") 
                    return "OK", 200
                post_id = change.get('media', {}).get('id', 'unknown')
                text = change.get('text', '')
                unix_timestamp = change.get('timestamp', int(datetime.datetime.now().timestamp()))
                timestamp = datetime.datetime.fromtimestamp(unix_timestamp, tz=timezone.utc)
                object_type = data.get('object', 'unknown')
                comment_id = change.get('comment_id') or change.get('id', 'unknown') 
                category = categorize(text)
                suggested_text = reply(text, category)   
                document_id = timestamp.isoformat().replace(":", "-").replace(".", "-") 

                db.collection('users').document(user_id).collection('messages').document(document_id).set({
                    'type': 'comment',
                    'sender': sender_username,
                    'sender_id': sender_id,
                    'post_id': post_id,
                    'comment_id' : comment_id,
                    'text': text,
                    'timestamp': timestamp,
                    'object': object_type, 
                    'category': category,
                    'suggested_reply': suggested_text,
                })
                print("✅ Yorum verisi Firestore'a yazildi.")
                
                
                if category in selected_categories:
                  reply_to_comment(comment_id, suggested_text)
                  print(f"🤖 Otomatik yanit gönderildi:")
                else:
                  print(f"⛔ '{category}' kategorisi seçilmediği için otomatik yanit gönderilmedi.")

            # DM mesajı varsa
            elif 'messaging' in entry:
                messaging = entry['messaging'][0]
                sender_id = messaging['sender'].get('id', 'unknown')
                if sender_id == IG_ID:
                    print("⏭️ Kendi bot mesaji tespit edildi, işlenmedi.") 
                    return "OK", 200
                    
                text = messaging.get('message', {}).get('text', '')
                unix_timestamp = messaging.get('timestamp', int(datetime.datetime.now().timestamp() * 1000))
                timestamp = datetime.datetime.fromtimestamp(unix_timestamp / 1000, tz=timezone.utc)
                object_type = data.get('object', 'unknown')
                category = categorize(text)
                suggested_text = reply(text, category)   
                document_id = timestamp.isoformat().replace(":", "-").replace(".", "-") 
                db.collection('users').document(user_id).collection('messages').document(document_id).set({
                    'type': 'dm',
                    'sender': sender_id,
                    'text': text,
                    'timestamp': timestamp,
                    'object': object_type,
                    'category': category,
                    'suggested_reply': suggested_text,
                })
                print("✅ DM verisi Firestore'a yazildi.")

                if category in selected_categories:
                  send_dm_reply(sender_id, suggested_text)
                  print(f"🤖 Otomatik yanit gönderildi:")
                else:
                  print(f"⛔ '{category}' kategorisi seçilmediği için otomatik yanit gönderilmedi.")

            else:
                print("❌ Webhook verisi tanımlanamayan yapı içeriyor.")

        except Exception as e:
            print("❌ Firestore hatası:", e)

        return "OK", 200
