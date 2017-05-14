FROM lsiobase/mono
MAINTAINER sparklyballs

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

# set env variables needed for subliminal to run
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# add sonarr repository
RUN \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
 echo "deb http://apt.sonarr.tv/ master main" > \
	/etc/apt/sources.list.d/sonarr.list && \

# install packages
 apt-get update && \
 apt-get install -y \
	nzbdrone \
	python3 \
	python3-pip \
	nodejs \
	at && \

# install subliminal
 pip3 install subliminal && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# set run-subliminal permissions
RUN chmod +x /opt/run-subliminal

# ports and volumes
EXPOSE 8989
VOLUME /config /downloads /tv
