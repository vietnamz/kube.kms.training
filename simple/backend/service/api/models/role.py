from api import db
import datetime

class Role(db.Model):
    """This class represents the various makes and models of gender table
    It corresponds to the gender table"""

    __tablename__ = 'um_user_role'

    role_id = db.Column(name='role_id',
                        type_=db.Integer,
                        primary_key=True,
                        nullable=False,
                        autoincrement=True,
                        comment='Unique Identifier for each role.')

    role_name = db.Column(name='role_name',
                          type_=db.String(255),
                          nullable=True,
                          comment='role name.',
                          index=True)

    role_note = db.Column(name='role_note',
                          type_=db.String(255),
                          nullable=True,
                          comment='role note.',
                          index=True)

    active = db.Column(name='active',
                       type_=db.Boolean,
                       default=True,
                       nullable=True,
                       comment='If true, this entry is still active.')

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
    def get_role_by(**kwargs):
        user = Role.query.filter_by(kwargs).first()
        return user

    def __repr__(self):
        return "<{}: {} {}>".format(self.__class__.__name__, self.role_id, self.role_name)
