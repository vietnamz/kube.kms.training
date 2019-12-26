"""
-- user
  "customer": {
    "schema": {
      "customer_id": 1,
      "name": "Lannucci",
      "email": "lannucci@hotmail.com",
      "address_1": "QI 19",
      "address_2": "",
      "city": "",
      "region": "",
      "postal_code": "",
      "country": "",
      "shipping_region_id": 1,
      "day_phone": "+351323213511235",
      "eve_phone": "+452436143246123",
      "mob_phone": "+351323213511235",
      "credit_card": "XXXXXXXX5100"
    }
  },
  "accessToken": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiY3VzdG9tZXIiLCJpYXQiOjE1NTA0MjQ0OTgsImV4cCI6MTU1MDUxMDg5OH0.aEFrNUPRWuRWx0IOEL-_A4J4Ti39iXEHAScm6GI61RR",
  "expires_in": "24h"
"""

from flask_restplus import fields
from api import api

error = api.model('Error', {
    'code': fields.String(example='USR_02'),
    'message': fields.String(example='Endpoint not found.'),
    'field': fields.String(example='The field example is empty.'),
    'status': fields.String(example='500')
})

unauthorized = api.model('Unauthorized', {
    'code': fields.String(example='AUT_02'),
    'message': fields.String(example='The Api key is invalid.'),
    'field': fields.String(example='API-KEY')
})

notfound = api.model('NotFound', {
    'message': fields.String(example='Endpoint not found.'),
})

user_res_scheme = api.model('schema', {
    'user_id': fields.Integer(description='The user identifier', example='The unique identifier of user'),
    'supervisor_user_id': fields.Integer(description='The supervisor identifier', example=1),
    'user_gender_id': fields.Integer(description='user gender identifier', example=1),
    'account_name': fields.String(description='the account name', example='Tam'),
    'email': fields.String(description='User Email', example='tamdm@d-soft.com.vn'),
    'common_name': fields.String(description='The user common name', example='Nhi'),
    'given_name': fields.String(description='The user given name', example='Dang'),
    'middle_name': fields.String(description='The user middle name', example='Minh'),
    'family_name': fields.String(description='The user family name', example='Dang'),
    'full_name': fields.String(description='The user full name', example='Dang Minh Tam'),
    'user_note': fields.String(description='The user note', example='This is a admin user'),
    'credit_card': fields.String(description='The user credit card', example='xxxxxxxxxxx'),
    'address_1': fields.String(description='The first address of user', example='Sai gon'),
    'address_2': fields.String(description='The second address of user', example='Truong Chinh'),
    'city': fields.String(description='the user city', example='Sai Gon'),
    'region': fields.String(description='The region of user coutry', example='Asia'),
    'postal_code': fields.String(description='The postal code', example=''),
    'country': fields.Integer(description='The user country', example='Viet Nam'),
    'day_phone': fields.String(description='Company phone', example="+351323213511235"),
    'eve_phone': fields.String(description='personal phone', example="+351323213511235"),
    'mob_phone': fields.String(description='mobile phone', example="+351323213511235"),
    'photo_1': fields.String(description='The avatar photo', example='s3:xxxx/xxxx'),
    'photo_2': fields.String(description='The thumbnail photo', example='s3:xx/xx'),
    'external_user': fields.Boolean(description='True if the user from external source like facebook, google',
                                    example=True),
    'active': fields.Boolean(description='True if the user is active', example=True),
    'create_by_user_id': fields.Integer(description='Who created this user', example=1),
    'create_date': fields.DateTime(description='when this user was created', example=''),
    'updated_by_user_id': fields.Integer(description='Updated by', example=''),
    'updated_date': fields.DateTime(description='', example=''),
    'firebase_uuid': fields.String(description='Firebase identifier',
                                   example='djdalkjajlkajklgjakljgkla')
})

user_res = api.model('UserModel', {
    'user':  fields.Nested(api.model('schemas', {
        'schema': fields.Nested(user_res_scheme),
    })),
    'access_token': fields.String(description='The access token',
                                  example="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiY3VzdG9tZXIiLCJpYXQiOjE1NTA0MjQ0OTgsImV4cCI6MTU1MDUxMDg5OH0.aEFrNUPRWuRWx0IOEL-_A4J4Ti39iXEHAScm6GI61RR"),
    'expires_in': fields.String(description='When token expires', example='24h')
})

token_validation = api.model('TokenValidation', {
    'validated': fields.Boolean(description='true if validated',
                                example='False')
})
