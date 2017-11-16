FROM ubuntu:14.04


# Let's start with some basic stuff.
RUN chgrp -R 0 /var && chmod -R g=u /var 
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
    
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the magic wrapper.
ADD scripts/wrapdocker /usr/local/bin/wrapdocker
RUN chmod 777 /usr/local/bin/wrapdocker
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
USER root
RUN update-rc.d docker defaults
# Define additional metadata for our image.
ENTRYPOINT [ "uid_entrypoint" ] 

VOLUME /var/lib/docker
CMD ["wrapdocker"]

