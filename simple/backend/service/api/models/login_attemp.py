from api import db
import datetime

class LoginAttempt(db.Model):
    """This class represents the various makes and models of gender table
    It corresponds to the gender table"""

    __tablename__ = 'um_login_attempt'

    login_attempt_id = db.Column(name='login_attempt_id',
                                 type_=db.Integer,
                                 primary_key=True,
                                 nullable=False,
                                 autoincrement=True,
                                 comment='Unique Identifier of login counter.')

    account_name = db.Column(name='account_name',
                             type_=db.String(255),
                             nullable=True,
                             comment='account name.')

    email = db.Column(name='email',
                      type_=db.String(255),
                      nullable=False,
                      comment='email')

    password = db.Column(name='password',
                         type_=db.String(255),
                         nullable=False,
                         comment='password')

    ip_number = db.Column(name='ip_number',
                          type_=db.String(45),
                          nullable=True,
                          comment='ip address')

    browser_type = db.Column(name='browser_type',
                             type_=db.String(255),
                             nullable=True,
                             comment='Which browser')

    success = db.Column(name='success',
                        type_=db.Boolean,
                        nullable=True,
                        comment='True if success')

    created_date = db.Column(name='created_data',
                             type_=db.DateTime,
                             nullable=True,
                             default=datetime.datetime.utcnow,
                             comment='Created time')

    def __init__(self, **kwargs):
        self.gender_name = kwargs.pop('email')
        self.password = kwargs.pop('password')
        self.email = kwargs.pop('email')

    def save(self):
        db.session.add(self)
        db.session.commit()
        return self.user_id

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def get_loging_attempt_by(**kwargs):
        user = LoginAttempt.query.filter_by(kwargs).first()
        return user

    def __repr__(self):
        return "<{}: {} {} {}>".format(self.__class__.__name__, self.login_attempt_id, self.email, self.password)
