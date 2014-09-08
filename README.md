# mi-core-django

This repository is based on [Joyent mibe](https://github.com/joyent/mibe). Please note this repository should be build with the [mi-core-base](https://github.com/skylime/mi-core-base) mibe image.

## warning

This mibe image is only for testing!

## mdata variables

- `nginx_ssl`: ssl certificate for the web interface
- `django_url`: URL to an `tar.gz` archive which contains your django code
- `django_project`: name of the django project that contains the `wsgi.py` file

## services

- `80/tcp`: http webserver
- `443/tcp`: https webserver
