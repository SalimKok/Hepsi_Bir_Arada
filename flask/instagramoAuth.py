from flask import Flask, redirect, request
import requests

app = Flask(__name__)

INSTAGRAM_APP_ID = '620500921086035'       # Meta Developers'dan aldığın App ID
INSTAGRAM_APP_SECRET = '2800c5dd9ab2c08bb0016c37bee02e88'   # App Secret
REDIRECT_URI = 'https://d2b232225e16.ngrok-free.app/instagramoAuth/callback'  # Instagram OAuth Redirect URI

# 1. Instagram OAuth başlatma endpoint'i
@app.route('/instagramoAuth/login')
def instagram_login():
    oauth_url = (
        f'https://www.facebook.com/v23.0/dialog/oauth?'
        f'client_id={INSTAGRAM_APP_ID}'
        f'&redirect_uri={REDIRECT_URI}'
        f'&scope=instagram_basic,pages_show_list,pages_read_engagement'
        f'&response_type=code'
    )
    return redirect(oauth_url)

# 2. Instagram OAuth callback - authorization code alındıktan sonra access token isteği
@app.route('/instagramoAuth/callback')
def instagram_callback():
    code = request.args.get('code')
    if not code:
        return 'Authorization code gelmedi.', 400

    # Access token almak için istek
    token_url = 'https://graph.facebook.com/v23.0/oauth/access_token'
    params = {
        'client_id': INSTAGRAM_APP_ID,
        'client_secret': INSTAGRAM_APP_SECRET,
        'redirect_uri': REDIRECT_URI,
        'code': code
    }
    response = requests.get(token_url, params=params)
    data = response.json()

    access_token = data.get('access_token')
    if not access_token:
        return f"Access token alınamadı: {data}", 400

    # Burada token'ı veritabanına kaydetmeli veya kullanıcı ile ilişkilendirmelisin
    print('Access Token:', access_token)

    # Kullanıcıya basit bir onay sayfası göster
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
