sd-django
=========

A `Django <https://www.djangoproject.com/>`_ + `Gunicorn <http://gunicorn.org/>`_ Dockerfile compatible with the `spin-docker PaaS <https://github.com/atbaker/spin-docker>`_. The sample Django included is based off the `Two Scoops of Django sample project layout <https://github.com/twoscoops/django-twoscoops-project>`_.

Quickstart
----------

This image is available as a trusted build on the docker index. The easiest way to get it on your server is using ``docker pull``:

.. code-block:: bash

    $ docker pull atbaker/sd-django

Alternatively, you can clone this repository and build the image yourself:

.. code-block:: bash

    $ docker build -t=sd-django .

Using this image
----------------

This image is very insecure! It uses `Phusion's baseimage-docker <https://github.com/phusion/baseimage-docker>`_ and its insecure key for SSH authentication. It also exposes Gunicorn directly as a webserver (it is more common to place it behind `Nginx <http://wiki.nginx.org/Main>`_). **Do not use this image in production without modification.**

Once you have started a container from this image, you can access it via SSH:

.. code-block:: bash
    
    # Use your container's host and port
    $ ssh -i insecure_key root@127.0.0.1 -p 49153

Or can connect to the webserver directly from a browser or the command line:

.. code-block:: bash

    # Use your container's host and port
    $ curl http://127.0.0.1:49154

Learn more
----------

Learn more about this image and how to use it in the spin-docker documentation: http://spin-docker.readthedocs.org/

Learn more about Dockerfiles and how to build them in the Docker documentation: http://docs.docker.io/en/latest/reference/builder/
