from flask import Flask
from flask_restful import Api
import firebase_admin
from firebase_admin import credentials

from routes.protected import protected
from routes.message import MessageAPI  

cred = credentials.Certificate("firebase_key.json")

# initialize_app()'i birden fazla çağırmayı önlemek için kontrol
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

app = Flask(__name__)
api = Api(app)  # Flask-RESTful API nesnesi oluştur

app.register_blueprint(protected)  

api.add_resource(MessageAPI, "/api/messages")  # /api/messages endpoint'ini tanımla

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
