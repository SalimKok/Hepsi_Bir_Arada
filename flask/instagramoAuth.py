from flask import Flask, redirect, request
import requests
import firebase_admin
from firebase_admin import credentials, firestore
import base64

app = Flask(__name__)

# Instagram API bilgileri
INSTAGRAM_APP_ID = '620500921086035'
INSTAGRAM_APP_SECRET = '2800c5dd9ab2c08bb0016c37bee02e88'
REDIRECT_URI = 'https://dcda6fd4cd40.ngrok-free.app/instagramoAuth/callback'

# Firebase bağlantısı
cred = credentials.Certificate('firebase_key.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# Token'ı basitçe base64 ile encode ediyoruz (daha gelişmiş şifreleme için AES vs. kullanılabilir)
def encrypt_token(token: str) -> str:
    return base64.b64encode(token.encode()).decode()

@app.route('/instagramoAuth/login')
def instagram_login():
    oauth_url = (
        f'https://graph.facebook.com/v23/oauth/client_code??'
        f'client_id={INSTAGRAM_APP_ID}'
        f'&redirect_uri={REDIRECT_URI}'
        f'&scope=instagram_basic,pages_show_list,pages_read_engagement'
        f'&response_type=code'
    )
    return redirect(oauth_url)

@app.route('/instagramoAuth/callback')
def instagram_callback():
    print("Callback endpoint tetiklendi!")
    code = request.args.get('code')
    if not code:
        return 'Authorization code gelmedi.', 400

    token_url = 'https://api.instagram.com/oauth/access_token'
    params = {
        'client_id': INSTAGRAM_APP_ID,
        'client_secret': INSTAGRAM_APP_SECRET,
        'grant_type': 'authorization_code',
        'redirect_uri': REDIRECT_URI,
        'code': code
    }

    response = requests.post(token_url, data=params)
    data = response.json()

    access_token = data.get('access_token')
    user_id = data.get('user_id')

    if not access_token or not user_id:
        return f"Access token alınamadı: {data}", 400

    encrypted_token = encrypt_token(access_token)

    # Firestore'a kaydet
    db.collection('Sosyal_Medya_Hesaplari').document(str(user_id)).set({
        'platform': 'instagram',
        'user_id': user_id,
        'access_token_encrypted': encrypted_token
    })

    return '''
        <html>
          <body style="text-align: center; font-family: sans-serif; margin-top: 50px;">
            <h2>Instagram hesabınız başarıyla bağlandı!</h2>
            <p>Uygulamaya geri dönebilirsiniz.</p>
          </body>
        </html>
    '''

if __name__ == '__main__':
    app.run(port=5000, debug=True)

  

