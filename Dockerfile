# Spin-docker example dockerfile for a Two Scoops-style Django project
# https://github.com/atbaker/spin-docker | https://github.com/twoscoops/django-twoscoops-project

# Use phusion/baseimage as base image
FROM phusion/baseimage:0.9.8

MAINTAINER Andrew T. Baker <andrew@andrewtorkbaker.com>

# Set correct environment variables
ENV HOME /root

# Use the phusion baseimage's insecure key
RUN /usr/sbin/enable_insecure_key

# Add the Django app to the container and install its requirements
ADD sd_sample_project /var/www/django
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip
RUN pip install virtualenv
RUN virtualenv /var/www/venv
RUN /var/www/venv/bin/pip install -r /var/www/django/requirements/production.txt

# Syncdb (a sqlite3 database for simplicity)
ENV PYTHONPATH $PYTHONPATH:/var/www/django/sd_sample_project
ENV DJANGO_SETTINGS_MODULE sd_sample_project.settings.production
ENV SECRET_KEY no-so-secret # Fix for your own site!
RUN /var/www/venv/bin/django-admin.py syncdb --migrate --noinput
RUN /var/www/venv/bin/django-admin.py collectstatic --noinput

# Create gunicorn log files
RUN mkdir /var/log/gunicorn
RUN touch /var/log/gunicorn/access.log
RUN touch /var/log/gunicorn/error.log

# Install gunicorn runit service
RUN mkdir /etc/service/gunicorn
ADD run_gunicorn.sh /etc/service/gunicorn/run
RUN chown root /etc/service/gunicorn/run

# Add a spin-docker client to report gunicorn access activity to spin-docker
ADD sd_gunicorn_client.py /opt/sd_client.py
ADD sd_client_crontab /var/spool/cron/crontabs/root
RUN chown root /opt/sd_client.py /var/spool/cron/crontabs/root

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Spin-docker currently supports exposing port 22 for SSH and
# one additional application port (our site will run on 80)
EXPOSE 22 80

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
