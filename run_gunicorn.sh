#!/bin/sh
# Use the exec command to start the app you want to run in this container.
# Don't let the app daemonize itself.

# `/sbin/setuser memcache` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.

# Read more here: https://github.com/phusion/baseimage-docker#adding-additional-daemons
# exec /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres -D /usr/local/pgsql/data
export PYTHONPATH=$PYTHONPATH:/var/www/django/sd_sample_project/sd_sample_project
export DJANGO_SETTINGS_MODULE='settings.production'
export SECRET_KEY='no-so-secret' # Fix for your own site!
# chdir /var/www/django/sd_sample_project/sd_sample_project
exec /var/www/venv/bin/gunicorn wsgi:application \
    --bind 0.0.0.0:80 \
    --access-logfile /var/log/gunicorn/access.log \
    --error-logfile /var/log/gunicorn/error.log
