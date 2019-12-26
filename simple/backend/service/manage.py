import os

from flask import Flask
from flask_migrate import Migrate, MigrateCommand
from flask_script import Manager

from api import db
from api.config import app_config


def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(app_config[config_name])
    app.config.from_pyfile('api/config.py')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    return app


app = create_app(config_name=os.getenv('APP_SETTINGS'))
migrate = Migrate(app, db)
manager = Manager(app)

manager.add_command('db', MigrateCommand)


if __name__ == '__main__':
    manager.run()
