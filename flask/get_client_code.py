import requests

# Değiştirmen gereken alanlar
app_id = '620500921086035'
app_secret = '2800c5dd9ab2c08bb0016c37bee02e88'
redirect_uri = 'https://dcda6fd4cd40.ngrok-free.app/instagramoAuth/callback'  # Örn: 'https://abc123.ngrok-free.app/instagramoAuth/callback'
long_lived_access_token = 'IGAAIlEHNj8DlBZAFBjVXpDa0NBZAHRncElObHlyeVNQeVdlZAGR6aXFpNFFYcjJuMGhKNzBDWDloQ0lJVXU4b3JRVXE2OHZAENjVEcm1kazFUdTBjTTBfZAzVCdkJYLThVVmpFNFk1WXlYenFlTmc4SzRhYm4wZAUlqYlRuX0U5MTRPMAZDZD'

# API endpoint'i
url = f"https://graph.facebook.com/v19.0/oauth/client_code"

# Parametreler
params = {
    'client_id': app_id,
    'client_secret': app_secret,
    'redirect_uri': redirect_uri,
    'access_token': long_lived_access_token
}

# GET isteği gönder
response = requests.get(url, params=params)

# Sonucu yazdır
if response.status_code == 200:
    print("Client Code Alındı:")
    print(response.json())
else:
    print("Hata oluştu:")
    print(response.status_code)
    print(response.text)
