FROM anapsix/alpine-java:8_jdk_nashorn

# Define environment variables.
ENV MULE_HOME=/opt/mule  \
    MULE_VERSION=4.3.0-ea2  \
    MULE_MD5=1c77132085645169b32647193e4ec265  \
    TZ=Asia/Kolkata  \
    MULE_USER=mule

# SSL Cert for downloading mule zip
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add ca-certificates && \
    update-ca-certificates && \
    apk --no-cache add openssl && \
    apk add --update tzdata && \
    rm -rf /var/cache/apk/*


RUN adduser -D -g "" ${MULE_USER} ${MULE_USER}

RUN mkdir /opt/mule-standalone-${MULE_VERSION} && \
    ln -s /opt/mule-standalone-${MULE_VERSION} ${MULE_HOME} && \
    chown ${MULE_USER}:${MULE_USER} -R /opt/mule*

RUN echo ${TZ} > /etc/timezone

USER ${MULE_USER}

# Checksum
RUN cd ~ && wget https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_VERSION}/mule-standalone-${MULE_VERSION}.tar.gz && \
    echo "${MULE_MD5}  mule-standalone-${MULE_VERSION}.tar.gz" | md5sum -c && \
    cd /opt && \
    tar xvzf ~/mule-standalone-${MULE_VERSION}.tar.gz && \
    rm ~/mule-standalone-${MULE_VERSION}.tar.gz

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

COPY app/test.jar /opt/mule/apps

# Define working directory.
WORKDIR ${MULE_HOME}

CMD [ "/opt/mule/bin/mule"]

# Default http port
EXPOSE 8081