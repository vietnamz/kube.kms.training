from api import db
import datetime


class Gender(db.Model):
    """This class represents the various makes and models of gender table
    It corresponds to the gender table"""

    __tablename__ = 'um_user_gender'

    gender_id = db.Column(name='gender_id',
                          type_=db.Integer,
                          primary_key=True,
                          nullable=False,
                          autoincrement=True,
                          comment='Unique Identifier for each gender.')

    gender_name = db.Column(name='gender_name',
                            type_=db.String(128),
                            nullable=True,
                            comment='gender identifier.',
                            index=True)

    created_by_user_id = db.Column(name='created_by_user_id',
                                   type_=db.Integer,
                                   nullable=True,
                                   comment='who created this entry')

    created_date = db.Column(name='created_data',
                             type_=db.DateTime,
                             nullable=True,
                             default=datetime.datetime.utcnow,
                             comment='Created time')

    modified_by_user_id = db.Column(name='modified_by_user_id',
                                    type_=db.Integer,
                                    nullable=True,
                                    comment='who modified this entry')

    modified_date = db.Column(name='modified_date',
                              type_=db.DateTime,
                              nullable=True,
                              comment='modified date')

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
    def get_gender_by(**kwargs):
        user = Gender.query.filter_by(kwargs).first()
        return user

    def __repr__(self):
        return "<{}: {} {}>".format(self.__class__.__name__, self.user_gender_id, self.gender_name)
