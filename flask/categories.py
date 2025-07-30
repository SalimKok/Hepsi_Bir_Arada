from flask import Blueprint, request, jsonify
from firebase_config import db

categories_bp = Blueprint('categories_bp', __name__)

@categories_bp.route('/api/categories', methods=['POST'])
def save_categories():
    try:
        data = request.get_json()
        user_id = data.get('user_id')
        categories = data.get('categories', [])

        if not user_id:
            return jsonify({'error': 'user_id eksik'}), 400

        db.collection('users').document(user_id).set({
            'categories': categories,
        })
        
        return jsonify({'message': 'Kategoriler kaydedildi'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@categories_bp.route('/api/categories', methods=['GET'])

def get_categories():
    try:
        user_id = request.args.get('user_id')

        if not user_id:
            return jsonify({'error': 'user_id eksik'}), 400

        doc = db.collection('users').document(user_id).get()

        if doc.exists:  
            categories = doc.to_dict().get('categories', [])
            return jsonify({'categories': categories}), 200
        else:
            return jsonify({'categories': []}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
def get_categories_internal(user_id):
    doc = db.collection('users').document(user_id).get()
    if doc.exists:
        return doc.to_dict().get('categories', [])
    else:
        return []    