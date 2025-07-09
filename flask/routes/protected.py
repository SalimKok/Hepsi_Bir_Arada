from flask import Blueprint, jsonify, request
from firebase_admin import auth
from functools import wraps

protected = Blueprint('protected', __name__)  

def firebase_token_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return jsonify({"error": "Token eksik"}), 401
        token = auth_header.split("Bearer ")[1]
        try:
            decoded_token = auth.verify_id_token(token)
            request.user = decoded_token
        except:
            return jsonify({"error": "Token gecersiz"}), 401
        return f(*args, **kwargs)
    return decorated_function

@protected.route('/protected-data', methods=['GET'])  #  Bu route var mı?
@firebase_token_required
def protected_data():
    return jsonify({"message": "Yetkili erisim basarili"})
