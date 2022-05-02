FROM node:16-alpine

ARG N8N_VERSION=0.175.0

RUN if [ -z "$N8N_VERSION" ] ; then echo "The N8N_VERSION argument is missing!" ; exit 1; fi

RUN wget http://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp-dev_2.5.4-1_armhf.deb

RUN sudo dpkg -i libseccomp2_2.5.5-1_armhf.deb


# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

# # Set a custom user to not have n8n run as root
USER root

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python build-base ca-certificates && \
	npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
	apk del build-dependencies

WORKDIR /data

CMD ["n8n"]

COPY docker-entrypoint.sh /tmp/docker-entrypoint.sh
ENTRYPOINT ["sh", "/tmp/docker-entrypoint.sh"]

EXPOSE 5678/tcp
