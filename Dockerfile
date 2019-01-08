##############################################################################
# Dockerfile to build Atlassian FishEye container images
# Based on Debian (https://hub.docker.com/r/_/debian/)
##############################################################################

FROM debian:stretch-slim

MAINTAINER Oliver Wolf <root@streacs.com>

ARG APPLICATION_RELEASE

ENV APPLICATION_INST /opt/atlassian/fisheye
ENV APPLICATION_HOME /var/opt/atlassian/application-data/fisheye

ENV SYSTEM_USER fisheye
ENV SYSTEM_GROUP fisheye
ENV SYSTEM_HOME /home/fisheye

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
  && mkdir /usr/share/man/man1
  
RUN set -x \
  && apt-get update \
  && apt-get -y --no-install-recommends install wget unzip ca-certificates git subversion ruby-rspec ssh openjdk-8-jdk-headless \
  && gem install serverspec

RUN set -x \
  && addgroup --system ${SYSTEM_GROUP} \
  && adduser --system --home ${SYSTEM_HOME} --ingroup ${SYSTEM_GROUP} ${SYSTEM_USER}

RUN set -x \
  && mkdir -p ${APPLICATION_INST} \
  && mkdir -p ${APPLICATION_HOME} \
  && wget --no-check-certificate -nv -O /tmp/fisheye-${APPLICATION_RELEASE}.zip https://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${APPLICATION_RELEASE}.zip \
  && unzip -q /tmp/fisheye-${APPLICATION_RELEASE}.zip -d /tmp/ \
  && mv /tmp/fecru-${APPLICATION_RELEASE}/* ${APPLICATION_INST} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${APPLICATION_INST} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${APPLICATION_HOME} \
  && rm -rf /tmp/fecru-${APPLICATION_RELEASE} \
  && rm /tmp/fisheye-${APPLICATION_RELEASE}.zip

RUN set -x \
  && apt-get clean \
  && rm -rf /var/cache/* \
  && rm -rf /tmp/*

RUN set -x \
  && touch -d "@0" "${APPLICATION_INST}/bin/fisheyectl.sh"

ADD files/service /usr/local/bin/service
ADD files/entrypoint /usr/local/bin/entrypoint
ADD files/healthcheck /usr/local/bin/healthcheck
ADD rspec-specs ${SYSTEM_HOME}/

VOLUME ${APPLICATION_HOME}

EXPOSE 8060

ENTRYPOINT ["/usr/local/bin/entrypoint"]

USER ${SYSTEM_USER}

WORKDIR ${SYSTEM_HOME}

HEALTHCHECK --interval=5s --timeout=3s CMD /usr/local/bin/healthcheck

CMD ["/usr/local/bin/service"]
