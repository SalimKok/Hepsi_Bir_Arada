# app.py

from flask import Flask
from flask_restful import Api
from flask_cors import CORS
from routes.message import MessageAPI

app = Flask(__name__)
CORS(app)
api = Api(app)

api.add_resource(MessageAPI, '/api/messages')

if __name__ == '__main__':
    app.run(debug=True)
