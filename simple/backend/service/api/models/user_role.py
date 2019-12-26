from api import db
import datetime


class UserRole(db.Model):
    """This class represents the various makes and models of gender table
    It corresponds to the gender table"""

    __tablename__ = 'um_user_user_role'

    user_id = db.Column(name='user_id',
                        type_=db.Integer,
                        primary_key=True,
                        nullable=False,
                        comment='Unique Identifier for each user.')

    role_id = db.Column(name='role_id',
                        type_=db.Integer,
                        primary_key=True,
                        nullable=False,
                        comment='Unique Identifier for each role.')

    create_date = db.Column(name='created_date',
                            type_=db.DateTime,
                            nullable=True,
                            default=datetime.datetime.utcnow,
                            comment='Created date')

    begin_date = db.Column(name='begin_date',
                           type_=db.DateTime,
                           nullable=True,
                           comment='begin time')

    end_date = db.Column(name='end_date',
                         type_=db.DateTime,
                         nullable=True,
                         comment='end date')

    def __init__(self, **kwargs):
        self.gender_name = kwargs.pop('gender_name')

    def save(self):
        db.session.add(self)
        db.session.commit()
        return self.user_id

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def get_user_role_by(**kwargs):
        user = UserRole.query.filter_by(kwargs).first()
        return user

    def __repr__(self):
        return "<{}: {} {}>".format(self.__class__.__name__, self.role_id, self.user_id)