#!/bin/bash

MAILDIR=${HOME}/.thunderbird
NSSDIR=${HOME}/.pki/nssdb
GPGDIR=${HOME}/.gnupg
EXCHANGE=${HOME}/Downloads

if [ ! -d ${MAILDIR} ]; then
	echo "MAILDIR ${MAILDIR} not found."
	exit 1
fi
if [ ! -d ${NSSDIR} ]; then
	echo "NSSDIR ${NSSDIR} not found."
	exit 1
fi
if [ ! -d ${GPGDIR} ]; then
	echo "GPGDIR ${GPGDIR} not found."
	exit 1
fi
if [ ! -d ${EXCHANGE} ]; then
	echo "EXCHANGE ${EXCHANGE} not found."
	exit 1
fi

docker run -d -ti --rm \
	--name thunderbird-sq -h thunderbird-sq \
	--ipc=host \
	-e PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native \
	-e DISPLAY=${DISPLAY} \
	-v /etc/alsa:/etc/alsa \
	-v /usr/share/alsa:/usr/share/alsa \
	-v /run/pcscd/pcscd.comm:/run/pcscd/pcscd.comm \
	-v /home/brf/.config/pulse:/home/user/.config/pulse \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/user/$(id -u)/pulse:/run/user/1000/pulse \
	-v ${MAILDIR}:/home/user/.thunderbird \
	-v ${NSSDIR}:/home/user/.pki/nssdb \
	-v ${GPGDIR}:/home/user/.gnupg \
	-v ${EXCHANGE}:/home/user/exchange \
	bfix/thunderbird-sq

