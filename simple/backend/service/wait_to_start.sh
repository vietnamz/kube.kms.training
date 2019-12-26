#!/bin/bash

/venv/bin/python manage.py db init
/venv/bin/python manage.py db migrate
/venv/bin/python manage.py db upgrade

/venv/bin/gunicorn --workers=1 --bind=0.0.0.0:5000 app:app
