FROM python:3.7-alpine

ADD requirements.txt /requirements.txt

RUN apk update && apk add linux-headers postgresql-dev gcc python3-dev musl-dev g++ \
    && python -m venv /venv \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install --no-cache-dir -r /requirements.txt"

RUN mkdir /code/
WORKDIR /code/
ADD . /code/

# Add any custom, static environment variables needed by Django or your settings file here:
ENV FLASK_APP=app.py
ENV APP_SETTINGS=local
ENV DATABASE_URL="postgresql+psycopg2://postgres:postgres@localhost:5432/user_mgr"
ENV FLASK_ENV=development
ENV GOOGLE_APPLICATION_CREDENTIALS=firebase.json
CMD ["/bin/sh", "/code/wait_to_start.sh"]
