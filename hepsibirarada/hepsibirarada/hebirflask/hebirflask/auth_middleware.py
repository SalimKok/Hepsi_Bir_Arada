# auth_middleware.py
from functools import wraps
from flask import request, jsonify
from firebase_admin import auth

def firebase_token_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization')

        if not auth_header or not auth_header.startswith('Bearer '):
            return jsonify({"error": "Yetki reddedildi: Authorization header yok"}), 401

        id_token = auth_header.split("Bearer ")[1]

        try:
            decoded_token = auth.verify_id_token(id_token)
            request.user = decoded_token  # Kullanıcı bilgilerini request'e ekle
        except Exception as e:
            return jsonify({"error": f"Token doğrulanamadi: {str(e)}"}), 401

        return f(*args, **kwargs)
    return decorated_function
