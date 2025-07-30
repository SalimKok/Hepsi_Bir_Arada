import requests
import os

INSTAGRAM_USER_ACCESS_TOKEN = os.getenv('ACCESS_TOKEN')  # .env üzerinden çekiyorsan
IG_ID = os.getenv('INSTAGRAM_IG_ID')  # Örn: "17841400000000000"

def send_dm_reply(recipient_ig_user_id, message_text):
    url = f'https://graph.instagram.com/v23.0/{IG_ID}/messages'
    headers = {
        'Authorization': f'Bearer {INSTAGRAM_USER_ACCESS_TOKEN}',
        'Content-Type': 'application/json'
    }
    payload = {
        "recipient": {
            "id": recipient_ig_user_id  # gelen mesajdaki sender ID
        },
        "message": {
            "text": message_text
        }
    }


    response = requests.post(url, headers=headers, json=payload)

    if response.status_code == 200:
        print("✅ Mesaj başarıyla gönderildi.")
    else:
        print("❌ Mesaj gönderme hatası:", response.status_code, response.text)


def reply_to_comment(comment_id, message):
    url = f"https://graph.instagram.com/v23.0/{comment_id}/replies"
    headers = {
        "Content-Type": "application/json"
    }
    payload = {
        "message": message,
        "access_token": INSTAGRAM_USER_ACCESS_TOKEN
    }

    response = requests.post(url, headers=headers, json=payload)

    if response.status_code == 200:
        print("✅ Yorum yanıtlandı:", response.json())
        return response.json()
    else:
        print("❌ Hata oluştu:", response.status_code, response.text)
        return None