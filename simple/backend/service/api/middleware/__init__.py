from typing import Any

from api.exception.invalid_usage import CustomException
from collections import defaultdict
from api.dal import DatabaseWrapper
from api.services.firebase import create_firebase_user, get_user, verify_token, get_user_by_uuid
from .user_attribute import UserAttribute


def _validate_input_form(header=None, form_data=None):
    if header and not isinstance(header, dict):
        raise CustomException('The header is not in dict form', '500', {'field': 'header',
                                                                        'code': 'USR_02'})
    if form_data and not isinstance(form_data, dict):
        raise CustomException('The user data is not in dict form', '500', {'field': 'user_data',
                                                                           'code': 'USR_02'})


def _validate_access_token(header, form_data):
    _validate_input_form(header, form_data)
    if len(form_data) < 1:
        raise CustomException('The user data is missing required field', '400', {'field': 'user_data',
                                                                                 'code': 'USR_02'})
    if not form_data.get('access_token'):
        raise CustomException('The access token is empty', '400', {'field': 'access_token', 'code': 'USR_09'})


def register_with_external(header=None, form_data=None):
    """ This method is used to perform login action from google

        :param: header: the dict is provided from request
                user_data: the user data is provided from request

        :return: return a success or exception
        :Raises: CustomException: a custom exception
    """

    _validate_access_token(header, form_data)
    _token = defaultdict()
    _token['access_token'] = form_data.get('access_token')
    user = get_user(**_token)
    if user is None:
        raise CustomException('The access token is invalid', '400', 
                              {'field': 'access_token', 'code': 'USR_09'})
    query = {'firebase_uuid': user.uid}
    existing_user = DatabaseWrapper.get_user_by(**query)
    if existing_user is not None:
        return existing_user
    _user = defaultdict()
    _user['email'] = user.email
    _user['name'] = user.display_name
    _user['full_name'] = user.display_name
    _user['photo_1'] = user.photo_url
    _user['external_user'] = True
    _user['firebase_uuid'] = user.uid
    _user['active'] = user.email_verified
    _user_obj = DatabaseWrapper.create_user(**_user)
    return _user_obj


def register_with_internal(header=None, form_data=None):

    """ This method is used to perform register action

        :param: header: the dict is provided from request
                user_data: the user data is provided from request

        :return: return a success or exception
        :Raises: CustomException: a custom exception
    """
    """
    TODO: define global error code for diagnosis
    """
    _validate_input_form(header, form_data)
    if len(form_data) < 3:
        raise CustomException('The user data is missing required field', '400', {'field': 'user_data',
                                                                                 'code': 'USR_02'})
    _user = defaultdict()
    if form_data.get('email'):
        _user['email'] = form_data.get('email')
    else:
        raise CustomException('The email is missing required field', '400', {'field': 'email',
                                                                             'code': 'USR_0'})
    existing_user = DatabaseWrapper.get_user_by(**_user)
    if existing_user is not None:
        raise CustomException('The email was taken', '400', {'field': 'email',
                                                             'code': 'USR_0'})
    if form_data.get('user'):
        _user['account_name'] = form_data.get('user')
    else:
        raise CustomException('The user name is missing required field', '400', {'field': 'account_name',
                                                                                 'code': 'USR_0'})
    _password = defaultdict()
    if form_data.get('password'):
        _password['password'] = form_data.get('password')
    else:
        raise CustomException('The password is missing required field', '400', {'field': 'password',
                                                                                'code': 'USR_0'})

    firebase_user = create_firebase_user(_user['email'], _password['password'])
    _user['firebase_uuid'] = firebase_user.uid
    _user['active'] = firebase_user.email_verified
    _user_obj = DatabaseWrapper.create_user(**_user)
    return _user_obj


def get_user_profile(data, which_type=None):
    if not data or data == '':
        raise CustomException('The user id is empty', '400', {'field': 'user_id',
                                                              'code': 'USR_0'})
    _user = defaultdict()
    if type(data) == str:
        if which_type == UserAttribute.FIREBASE_UID: # firebase_uuid
            _user['firebase_uuid'] = data
        else: # email
            _user['email'] = data
    else:
        _user['user_id'] = data
    _user_obj = DatabaseWrapper.get_user_by(**_user)
    if not _user_obj:
        raise CustomException('The user have not added into database', '500', {'field': 'Empty',
                                                                               'code': 'USR_0'})
    return _user_obj


def validate_access_token(header, form_data):
    _validate_access_token(header, form_data)
    _token = defaultdict()
    _token['access_token'] = form_data.get('access_token')
    return verify_token(**_token)


def _get_email(user, form_data):
    if form_data.get('email'):
        user['email'] = form_data.get('email')
    else:
        raise CustomException('The email is missing required field', '400', {'field': 'email',
                                                                             'code': 'USR_0'})


def _get_firebase_uid(user, form_data):
    if form_data.get('email'):
        user['firebase_uuid'] = form_data.get('firebase_uid')
    else:
        raise CustomException('The firebase uid is missing required field', '400', {'field': 'firebase_uid',
                                                                                    'code': 'USR_0'})


def _validate_email_exist(**kwargs):
    existing_user = DatabaseWrapper.get_user_by(**kwargs)
    if existing_user is not None:
        raise CustomException('The email was taken', '400', {'field': 'email',
                                                             'code': 'USR_0'})


def create_user(header=None, form_data=None):
    """ This method is used to perform create a new user

        :param: header: the dict is provided from request
                user_data: the user data is provided from request

        :return: return a success or exception
        :Raises: CustomException: a custom exception
    """
    """
    TODO: define global error code for diagnosis
    """
    _validate_input_form(header, form_data)
    """
    REVIEW: the information from frontend might change in the future. don't check this login for now
    if len(form_data) < 3:
        raise CustomException('The user data is missing required field', '400', {'field': 'user_data',
                                                                                 'code': 'USR_02'})
    """
    _user = defaultdict()
    _get_email(_user, form_data)
    _validate_email_exist(**_user)

    """
    REVIEW: safety to remove. Since we consider email as a mandatory field for now
        if form_data.get('user'):
        _user['account_name'] = form_data.get('user')
    else:
        raise CustomException('The user name is missing required field', '400', {'field': 'account_name',
                                                                                 'code': 'USR_0'})
    """

    """
    REVIEW: We don't control the sensitive information like password for now.
    """
    """_password = defaultdict()
    if form_data.get('password'):
        _password['password'] = form_data.get('password')
    else:
        raise CustomException('The password is missing required field', '400', {'field': 'password',
                                                                                'code': 'USR_0'})"""

    """
    REVIEW: Frontend handle this login for simplicity
    firebase_user = create_firebase_user(_user['email'], _password['password'])
    """
    _get_firebase_uid(_user, form_data)
    user = get_user_by_uuid(**_user)
    _user['name'] = user.display_name
    _user['full_name'] = user.display_name
    _user['photo_1'] = user.photo_url
    _user_obj = DatabaseWrapper.create_user(**_user)
    return _user_obj
