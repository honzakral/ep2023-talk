FROM python:3.11-alpine

WORKDIR /app
RUN pip install --no-cache-dir poetry gunicorn

COPY . .
RUN poetry install

CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 8 --timeout 0 mysite.wsgi:application
