#!/bin/bash

set -ex

python manage.py migrate --noinput
python manage.py collectstatic --noinput

exec gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 0 mysite.wsgi:application
