from flask_restplus import Resource, reqparse, marshal
from flask import request

from api import user_namespace
from api.dao import *
from api.middleware import *
from api.middleware.user_attribute import UserAttribute

register_data = reqparse.RequestParser()
register_data.add_argument('user', required=False, type=str, location='form', help="Name of User.")
register_data.add_argument('email', required=True, type=str, location='form', help='Email of User.')
register_data.add_argument('password', required=True, type=str, location='form', help='Password of User.')

login_data = reqparse.RequestParser()
login_data.add_argument('email', required=True, type=str, location='form', help='Email of User')
login_data.add_argument('password', required=True, type=str, location='form', help='Password of User')

access_token = reqparse.RequestParser()
access_token.add_argument('access_token', required=True, type=str,
                          location='form',
                          help='Token generated from your external provider login')

newly_user_data = reqparse.RequestParser()
newly_user_data.add_argument('email', required=True, type=str, location='form', help="email of User.")
newly_user_data.add_argument('firebase_uid', required=True, type=str, location='form', help='firebase uid of User.')


def _form_response(data, token, expires):
    resp = dict()
    resp['user'] = marshal(data, user_res_scheme, envelope='schema')
    resp['access_token'] = token  # TODO: let frontend handle this logic for now.
    resp['expires_in'] = expires  # TODO: from configuration
    return marshal(resp, user_res)


"""
TEST status: Happy case all passed.
REVIEW: The header should be eliminated from api gateway. 
        No header validated for now. Response with a fake token and expires.
"""
@user_namespace.route('/v1')
class User(Resource):
    @api.response(500, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(newly_user_data, validate=True)
    @api.doc(body=newly_user_data)
    def post(self):
        """
        Create a newly user
        """
        result = create_user(form_data=request.form)
        return _form_response(result, 'FOO BAR', '24h')


"""
TEST status: Happy case all passed.
REVIEW: The header should be eliminated from api gateway. 
        No header validated for now. Response with a fake token and expires.
"""
@user_namespace.route('/v1/<int:user_id>')
@api.param('user_id', 'User ID')
class UserWithId(Resource):
    @api.response(500, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    def get(self, user_id):
        """
        Retrieve a specific user information base backend user id
        """
        print('UserWithId')
        result = get_user_profile(user_id, UserAttribute.USER_ID)  # User ID attribute
        return _form_response(result, 'FOO BAR', '24h')



"""
TEST status: Happy case all passed.
REVIEW: The header should be eliminated from api gateway. 
        No header validated for now. Response with a fake token and expires.
"""
@user_namespace.route('/v1/email/<string:email>')
@api.param('email', 'Email')
class UserWithEmail(Resource):
    @api.response(500, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    def get(self, email):
        """
        Retrieve a specific user information base backend user id
        """
        print('Email')
        result = get_user_profile(email, UserAttribute.EMAIL)  # Email attribute
        return _form_response(result, 'FOO BAR', '24h')

"""
TEST status: Happy case all passed.
REVIEW: The header should be eliminated from api gateway. 
        No header validated for now. Response with a fake token and expires.
"""
@user_namespace.route('/v1/<string:firebase_uid>')
@api.param('firebase_uid', 'firebase ID')
class UserWithFirebaseId(Resource):
    @api.response(500, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    def get(self, firebase_uid):
        """
        Retrieve a specific user information base on firebase user id
        """
        print('UserWithFirebaseId')
        result = get_user_profile(firebase_uid, UserAttribute.FIREBASE_UID)  # Firebase UID
        return _form_response(result, 'FOO BAR', '24h')


@user_namespace.route('/v1/login')
class Login(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign in with username password
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


@user_namespace.route('/v1/register')
class LoginWithGoogle(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign up with email/password account
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


@user_namespace.route('/v1/google')
class LoginWithGoogle(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign up with google account
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


@user_namespace.route('/v1/facebook')
class LoginWithFacebook(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign up with facebook account
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


@user_namespace.route('/v1/github')
class LoginWithGithub(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign up with github account
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


@user_namespace.route('/v1/twitter')
class LoginWithTwitter(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(user_res, code=200,
                      description='Return a Object of User with auth credential.')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Sign up with twitter account
        """
        result = register_with_external(form_data=request.form)
        return _form_response(result,
                              'Bearer {}'.format(request.form.get('access_token')),
                              '24h')


"""
REVIEW: UN-TESTED yet. it takes a quite a time. 
        Postpone the token validate in the header for quick develop core logic 
"""
@user_namespace.route('/v1/token/validate')
class TokenValidation(Resource):
    @api.response(404, 'Return a error object.', error)
    @api.marshal_with(token_validation, code=200,
                      description='Return a Object of validated status')
    @api.expect(access_token, validate=True)
    def post(self):
        """
        Validate the access token
        """
        result = validate_access_token(form_data=request.form)
        return {'validated': result}
