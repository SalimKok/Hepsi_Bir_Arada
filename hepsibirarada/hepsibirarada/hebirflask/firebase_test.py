import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

db.collection("messages").add({
    "user_id": "test_kullanici",
    "platform": "test_platform",
    "message": "Bu test mesajıdır"
})

print("Veri yazıldı!")
