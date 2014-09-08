#!/bin/bash
# Configure django based on the requirements

if mdata-get django_url 1>/dev/null 2>&1 && \
   mdata-get django_project 1>/dev/null 2>&1; then
	# VARS
	PROJECT=$(mdata-get django_project)
	URL=$(mdata-get django_url)
	ADMIN_DJANGO=${ADMIN_DJANGO:-$(mdata-get django_admin 2>/dev/null)} || \
	ADMIN_DJANGO=$(od -An -N8 -x /dev/random | head -1 | tr -d ' ');
	mdata-put django_admin ${ADMIN_DJANGO}

	# Create django project
	mkdir /var/www/django
	curl -L "${URL}" | tar xz -C /var/www/django --strip-components=1

	# Setup
	cd /var/www/django
	[ -f "req.txt" ] && pip install -r req.txt
	./manage.py syncdb --noinput
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '${ADMIN_DJANGO}')" \
		| ./manage.py shell
	# Ugly workaround for STATIC_ROOT
	echo "STATIC_ROOT = '/var/www/static'" >> /var/www/django/${PROJECT}/settings.py
	./manage.py collectstatic --noinput

	# Have nice permissions
	chown -R www:www /var/www

	# Configure gunicorn
	svccfg -s gunicorn:django setprop config/app   = astring: ${PROJECT}.wsgi:application
	svcadm refresh gunicorn:django
	svcadm enable  gunicorn:django
	svcadm restart gunicorn:django
fi
