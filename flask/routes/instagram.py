# routes/instagram.py

from flask import Blueprint, request, jsonify
import requests
import os
from dotenv import load_dotenv

load_dotenv()
GRAPH_API_URL = os.getenv("GRAPH_API_URL", "https://graph.facebook.com/v19.0")

instagram = Blueprint("instagram", __name__)

@instagram.route("/get-all-comments", methods=["POST"])
def get_all_comments():
    data = request.json
    access_token = data.get("accessToken")

    if not access_token:
        return jsonify({"error": "accessToken gerekli"}), 400

    media_url = f"{GRAPH_API_URL}/me/media"
    media_params = {
        "fields": "id,caption",
        "access_token": access_token
    }

    try:
        media_res = requests.get(media_url, params=media_params)
        print("🛰️ Media Response:", media_res.text)
        media_res.raise_for_status()
        media_data = media_res.json().get("data", [])
    except Exception as e:
        return jsonify({"error": "Gonderiler alinamadi", "details": str(e)}), 500

    all_comments = []

    for media in media_data:
        media_id = media["id"]
        caption = media.get("caption", "")

        comments_url = f"{GRAPH_API_URL}/{media_id}/comments"
        comment_params = {
            "fields": "id,text,username,timestamp",
            "access_token": access_token
        }

        try:
            comment_res = requests.get(comments_url, params=comment_params)
            comment_res.raise_for_status()
            comments = comment_res.json().get("data", [])

            for comment in comments:
                comment["media_id"] = media_id
                comment["caption"] = caption

            all_comments.extend(comments)
        except Exception as e:
            print(f"⚠️ {media_id} yorumları alınamadı: {e}")
            continue

    return jsonify({"total": len(all_comments), "comments": all_comments})
