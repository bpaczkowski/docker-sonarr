FROM lsiobase/mono:LTS

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SONARR_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"
ENV SONARR_BRANCH="master"

# set env variables needed for subliminal to run
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq \
        python3 \
        python3-pip \
        nodejs \
        at && \
 echo "**** install sonarr ****" && \
 mkdir -p /opt/NzbDrone && \
  if [ -z ${SONARR_VERSION+x} ]; then \
	SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH} \
	| jq -r '.version'); \
 fi && \
 curl -o \
	/tmp/sonarr.tar.gz -L \
	"https://download.sonarr.tv/v2/${SONARR_BRANCH}/mono/NzbDrone.${SONARR_BRANCH}.${SONARR_VERSION}.mono.tar.gz" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/opt/NzbDrone --strip-components=1 && \

 echo "*** install busliminal ****" && \
 pip3 install subliminal && \

 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/tmp/*

# add local files
COPY root/ /

# set run-subliminal permissions
RUN chmod +x /opt/run-subliminal

# ports and volumes
EXPOSE 8989
VOLUME /config
