FROM python:3.11-alpine

WORKDIR /app
RUN pip install --no-cache-dir poetry gunicorn

COPY . .
RUN poetry install

CMD entrypoint.sh
