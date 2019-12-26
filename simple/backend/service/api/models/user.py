from api import db
import datetime


class User(db.Model):
    """This class represents the various makes and models of user table
    It corresponds to the user table"""

    __tablename__ = 'um_user'

    user_id = db.Column(name='user_id',
                        type_=db.Integer,
                        primary_key=True,
                        nullable=False,
                        autoincrement=True,
                        comment='Unique Identifier for each User.')

    supervisor_user_id = db.Column(name='supervisor_user_id',
                                   type_=db.Integer,
                                   default=1,
                                   nullable=True,
                                   comment='Allows a recursive link from a User to his/her Supervisor.',
                                   index=True)

    user_gender_id = db.Column(name='user_gender_id',
                               type_=db.Integer,
                               default=0,
                               nullable=True,
                               comment='Unknown, Male, Female, or lawful person.',
                               index=True)

    account_name = db.Column(name='account_name',
                             type_=db.String(255),
                             nullable=True,
                             comment='Name of this users login account.',
                             index=True)

    email = db.Column(name='email',
                      type_=db.String(255),
                      nullable=False,
                      index=True,
                      unique=True,
                      comment='email of user')

    common_name = db.Column(name='common_name',
                            type_=db.String(255),
                            nullable=True,
                            comment='Name commonly used in informal situations.')

    given_name = db.Column(name='give_name',
                           type_=db.String(255),
                           nullable=True,
                           comment='Individual Given Name')
    middle_name = db.Column(name='middle_name',
                            type_=db.String(255),
                            nullable=True,
                            comment='Middle Name or initial.')
    family_name = db.Column(name='family_name',
                            type_=db.String(255),
                            nullable=True,
                            comment='Family Name')
    full_name = db.Column(name='full_name',
                          type_=db.String(255),
                          nullable=True,
                          comment='The full name as used publicly.')
    user_note = db.Column(name='user_note',
                          type_=db.String(255),
                          nullable=True,
                          comment='Note about this user.')
    credit_card = db.Column(name='credit_card',
                            type_=db.String(128),
                            nullable=True,
                            comment='The user credit card')
    address_1 = db.Column(name='address_1',
                          type_=db.String(255),
                          nullable=True,
                          comment='Address 1')
    address_2 = db.Column(name='address_2',
                          type_=db.String(255),
                          nullable=True,
                          comment='Address 2')
    city = db.Column(name='city',
                     type_=db.String(128),
                     nullable=True,
                     comment='City')
    region = db.Column(name='region',
                       type_=db.String(128),
                       nullable=True,
                       comment='region')
    postal_code = db.Column(name='postal_code',
                            type_=db.String(64),
                            nullable=True,
                            comment='postal code for asia country')
    zip = db.Column(name='zip',
                    type_=db.String(64),
                    nullable=True,
                    comment='Zip code')
    country = db.Column(name='country',
                        type_=db.String(255),
                        nullable=True,
                        comment='country')
    day_phone = db.Column(name='day_phone',
                          type_=db.String(64),
                          nullable=True,
                          comment='Phone 1')
    eve_phone = db.Column(name='eve_phone',
                          type_=db.String(64),
                          nullable=True,
                          comment='Phone 2')
    mob_phone = db.Column(name='mob_phone',
                          type_=db.String(64),
                          nullable=True,
                          comment='Mobile phone')

    photo_1 = db.Column(name='photo1',
                        type_=db.String(255),
                        nullable=True,
                        comment='Photo 1')

    photo_2 = db.Column(name='photo2',
                        type_=db.String(255),
                        nullable=True,
                        comment='Photo 2')

    external_user = db.Column(name='external_user',
                              type_=db.Boolean,
                              default=False,
                              nullable=True,
                              comment='If true, this user gets external email instead of internal messages.')

    active = db.Column(name='active',
                       type_=db.Boolean,
                       default=True,
                       nullable=True,
                       comment='If true, this entry is still active.')

    create_by_user_id = db.Column(name='created_by_user_id',
                                  type_=db.Integer,
                                  default=1,
                                  nullable=True,
                                  comment='The UserID which was logged on during creation of this entry.')

    create_date = db.Column(name='created_date',
                            type_=db.DateTime,
                            nullable=True,
                            default=datetime.datetime.utcnow,
                            comment='Created date')

    updated_by_user_id = db.Column(name='modified_by_user_id',
                                   type_=db.Integer,
                                   nullable=True,
                                   default=1,
                                   comment='updated by user id')

    updated_date = db.Column(name='modified_date',
                             type_=db.DateTime,
                             comment='update date')

    firebase_uuid = db.Column(name='firebase_uuid',
                              type_=db.String(255),
                              index=True,
                              unique=True,
                              comment='Firebase UUID')

    def __init__(self, **kwargs):
        if kwargs.get('email'):
            self.email = kwargs.pop('email')
        if kwargs.get('name'):
            self.account_name = kwargs.pop('name')
        if kwargs.get('firebase_uuid'):
            self.firebase_uuid = kwargs.pop('firebase_uuid')
        if kwargs.get('photo_1'):
            self.photo_1 = kwargs.pop('photo_1')
        if kwargs.get('external_user'):
            self.external_user = kwargs.pop('external_user')
        if kwargs.get('full_name'):
            self.full_name = kwargs.pop('full_name')
        if kwargs.get('active'):
            self.active = kwargs.pop('active')

    def save(self):
        db.session.add(self)
        db.session.commit()
        return self.user_id

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def get_user_by(**kwargs):
        user = User.query.filter_by(**kwargs).first()
        return user

    def __repr__(self):
        return "<{}: {} {} {}>".format(self.__class__.__name__, self.user_id, self.email, self.firebase_uuid)
