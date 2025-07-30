from flask import Blueprint, request, jsonify
import os
from oto_request import reply_to_comment, send_dm_reply

send_reply_bp = Blueprint('send_reply', __name__)

@send_reply_bp.route('/api/send_reply', methods=['POST'])
def send_reply():
    try:
        data = request.get_json()
        sender_id = data.get('sender')
        reply_text = data.get('reply')
        comment_id = data.get('comment_id')

        if comment_id:
            result = reply_to_comment(comment_id, reply_text)
        elif sender_id:
            result = send_dm_reply(sender_id, reply_text)
        else:
            return jsonify({'error': 'comment_id veya sender_id gereklidir'}), 400

        if result:
            return jsonify({'success': True, 'message': 'Yanıt gönderildi'})
        else:
            return jsonify({'success': False, 'error': 'Yanıt gönderilemedi'}), 500 

    except Exception as e:
        return jsonify({'error': str(e)}), 500
