from flask import request
from flask_restful import Resource
from firebase_config import db

class MessageAPI(Resource):
    def post(self):
        try:
            data = request.get_json()
            print("📥 İstek alındı:", data)

            user_id = data.get('user_id')
            platform = data.get('platform')
            message = data.get('message')

            print(f"👤 Kullanıcı ID: {user_id}")
            print(f"📱 Platform: {platform}")
            print(f"💬 Mesaj: {message}")

            # Firestore'a yazma işlemi
            db.collection("messages").add({
                "user_id": user_id,
                "platform": platform,
                "message": message
            })

            print("✅ Firestore’a yazıldı.")
            return {"status": "success", "message": "Firestore’a kaydedildi"}, 201

        except Exception as e:
            print("❌ Firestore hatası:", e)
            return {"status": "error", "message": str(e)}, 500
