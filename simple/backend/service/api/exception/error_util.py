from .invalid_usage import CustomException


def _extract_error_field(msg):
    first_index = msg.find('(') + 1
    second_index = msg.find(')')
    return msg[first_index:second_index]


def convert_integrity_ex_to_custom(err):
    err_msg = str(err.orig)
    status = '500'
    field = _extract_error_field(str(err.orig))
    return CustomException(err_msg, status, {'field': field})


def convert_firebase_ex_to_custom(e):
    err_msg = str(e)
    status = '500'
    field = 'firebase'
    return CustomException(err_msg, status, {'field': field})
