#!/bin/bash
UUID=$(mdata-get sdc:uuid)
DDS=zones/$UUID/data

if zfs list $DDS 1>/dev/null 2>&1; then
	zfs set mountpoint=/var/www $DDS
	chown www:www /var/www
fi
