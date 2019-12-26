from firebase_admin import auth
from api.exception.invalid_usage import CustomException


def create_firebase_user(email, password):
    return auth.create_user(email=email, password=password)


def _handle_verify_access_token(access_token):
    """ This method is used to self - check token if it valid or not
        :param: access_token: string token need to be verified
        
        :return: uid of user if input access_token is valid
                 None if access_token is invalid
    """
    try:
        decoded_token = auth.verify_id_token(access_token)
    except ValueError:
        return None
    return decoded_token['uid']


def _get_token(**kwargs):
    if not kwargs.get('access_token'):
        raise CustomException('The access_token is missing required field', '400', {'field': 'access_token',
                                                                                    'code': 'USR_02'})
    access_token = kwargs.pop('access_token')
    return access_token


def get_user(**kwargs):
    access_token = _get_token(**kwargs)
    uid = _handle_verify_access_token(access_token)
    if uid is None:
        return None
    user = auth.get_user(uid)
    return user

def get_user_by_uuid(**kwargs):
    uid = kwargs.get("firebase_uuid")
    user = auth.get_user(uid)
    return user


def verify_token(**kwargs):
    access_token = _get_token(**kwargs)
    if _handle_verify_access_token(access_token):
        return True
    else:
        return False
