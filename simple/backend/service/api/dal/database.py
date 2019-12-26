from api.models.user import User
from api.models.gender import  Gender
from api.models.login_attemp import LoginAttempt
from api.models.role import Role
from api.models.user_role import UserRole

class DatabaseWrapper(object):

    """ This static method is used to retrieve user information from a dictionary.
    
        :param: 
        value: the dict is provided
        
        :return:
        return a user row

        :raises Integrity error,

    """
    @staticmethod
    def create_user(**kwargs):
        user = User(**kwargs)
        user.save()
        return user

    @staticmethod
    def get_user_by(**kwargs):
        """ This static method is used to retrieve user information from a dictionary.

            :param:
            value: the dict is provided

            :return:
            return a user row
        """
        return User.get_user_by(**kwargs)
