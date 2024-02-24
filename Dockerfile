
############################################################
# Dockerfile to build  >Y< Thunderbird image.
# Copyright (c) 2014-2024 by Bernd Fix. All rights reserved.
############################################################

#===========================================================
# Builder for Sequoia Octopus
#===========================================================

FROM debian:bookworm AS builder

LABEL maintainer "Bernd Fix <brf@hoi-polloi.org>"

ENV DEBIAN_FRONTEND noninteractive

# install Rust compiler and environment
RUN \
	apt update && \
	apt upgrade -y && \
	apt install -y --no-install-recommends \
		ca-certificates \
		curl \
		&& \
	apt clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ~/rustup.sh && \
	sh ~/rustup.sh -y

# install dependencies for Sequoia
RUN \
	apt update && \
	apt install -y --no-install-recommends \
		clang \
		git \
		libssl-dev \
		libsqlite3-dev \
		librust-openssl-sys-dev \
		llvm \
		nettle-dev \
		pkg-config \
		&& \
	apt clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# build Sequoia Octopus
RUN \
	cd /root && \
	git clone https://gitlab.com/sequoia-pgp/sequoia-octopus-librnp && \
	cd sequoia-octopus-librnp && \
	git checkout main && \
	${HOME}/.cargo/bin/cargo build --release && \
	cp target/release/libsequoia_octopus_librnp.so /root/

#===========================================================
# Deployment image
#===========================================================

FROM debian:bookworm AS deploy

LABEL maintainer "Bernd Fix <brf@hoi-polloi.org>"

#-----------------------------------------------------------
# Install application.
#-----------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt update && \
	apt install -y --no-install-recommends \
		thunderbird \
		pinentry-curses \
		pinentry-tty \
		pinentry-qt \
		pinentry-gtk2 \
		dirmngr \
		pcsc-tools \
		gnupg \
		scdaemon \
		scute \
		ykcs11 \
		libssl-dev \
		libengine-pkcs11-openssl \
		opensc \
		locales \
		tzdata \
		pulseaudio-utils \
		dconf-gsettings-backend \
		fonts-noto-cjk \
		fonts-noto-core \
		fonts-noto-extra \
		fonts-noto-mono \
		glib-networking \
		libavahi-client3 \
		libavahi-common-data \
		libbotan-2-19 \
		libcap2 \
		libdeflate0 \
		libfontenc1 \
		libip4tc2 \
		libjbig0 \
		libjson-glib-1.0-0 \
		libkmod2 \
		libpangocairo-1.0-0 \
		libsoup-gnome2.4-1 \
		libthai0 \
		systemd-timesyncd \
		&& \
	apt clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY pulse-client.conf /etc/pulse/client.conf

COPY --from=builder /root/libsequoia_octopus_librnp.so /usr/lib/thunderbird/

RUN \
	dpkg-divert --divert /usr/lib/thunderbird/librnp-orig.so --rename /usr/lib/thunderbird/librnp.so && \
	ln -sf libsequoia_octopus_librnp.so /usr/lib/thunderbird/librnp.so

#-----------------------------------------------------------
# Setup application user.
#-----------------------------------------------------------

RUN \
	addgroup --gid 1000 user && \
	adduser \
		--home /home/user \
		--shell /bin/bash \
		--uid 1000 --gid 1000 \
		--quiet \
		user > /dev/null 2>&1

#-----------------------------------------------------------
# Run application.
#-----------------------------------------------------------

COPY run-client /usr/bin/

USER user
ENV HOME /home/user
ENV LANG en_US.utf8 
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.utf8     

CMD ["/usr/bin/run-client"]

