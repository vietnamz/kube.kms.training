import os

from flask import Flask
from flask_restplus import Api, Namespace
from flask_sqlalchemy import SQLAlchemy

from api.config import app_config

from api.exception.invalid_usage import CustomException
from api.exception.error_util import *
from sqlalchemy.exc import IntegrityError
import firebase_admin
from firebase_admin.auth import AuthError
from flask_cors import CORS


db = SQLAlchemy()
config_name = os.getenv('APP_SETTINGS')

app = Flask(__name__)
CORS(app)

monitoring_namespace = Namespace(
    "monitoring",
    description="Monitoring and health check data"
)

user_namespace = Namespace(
    "users",
    description='Everything about User'
)
authorizations = {
    'Bearer Auth': {
        'type': 'apiKey',
        'in': 'header',
        'name': 'Authorization'
    },
}
api = Api(app, api_version='1.1', doc='/docs', title='Backend API',
          description='Official documentation about connectome Ecommerce API.',
          contact='connectome', contact_email='delgemoon@gmail.com',
          security='Bearer Auth', authorizations=authorizations)

api.add_namespace(monitoring_namespace)
api.add_namespace(user_namespace)
app.config.from_object(app_config[config_name])
app.config.from_pyfile('config.py')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['RESTPLUS_MASK_SWAGGER'] = False


@api.errorhandler(CustomException)
def handle_custom_exception(e):
    return e.to_dict(), 400


@api.errorhandler(IntegrityError)
def handle_integrity_error(e):
    err = convert_integrity_ex_to_custom(e)
    return err.to_dict(), 400


@api.errorhandler(AuthError)
def handle_firebase_exception(e):
    err = convert_firebase_ex_to_custom(e)
    return err.to_dict(), 400


@api.errorhandler(ValueError)
def handle_value_error(e):
    print(e)
    err = CustomException(str(e), '500', {'field': 'access_token'})
    return err.to_dict(), 400


from api.views import health, user

db.init_app(app)

firebase_admin.initialize_app()
