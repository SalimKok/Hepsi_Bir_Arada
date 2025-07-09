from flask import request
from flask_restful import Resource
from firebase_config import db

class MessageAPI(Resource):
    def post(self):
        try:
            data = request.get_json()
            print("İstek alindi:", data)

            user_id = data.get('user_id')
            platform = data.get('platform')
            message = data.get('message')

            print(f"Kullanici ID: {user_id}")
            print(f"Platform: {platform}")
            print(f"Mesaj: {message}")

            # Firestore'a yazma işlemi
            db.collection("messages").add({
                "user_id": user_id,
                "platform": platform,
                "message": message
            })

            print("Firestore yazildi.")
            return {"status": "success", "message": "Firestore kaydedildi"}, 201

        except Exception as e:
            print("Firestore hatasi:", e)
            return {"status": "error", "message": str(e)}, 500
