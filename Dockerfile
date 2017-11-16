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
ADD entry/*.* /usr/local/bin/
RUN chmod 777 /usr/local/bin/wrapdocker
USER root
RUN update-rc.d docker defaults
# Define additional metadata for our image.
RUN chmod g=u /etc/passwd 
ENTRYPOINT [ "/usr/local/bin/uid_entrypoint.sh" ] 

VOLUME /var/lib/docker
CMD ["wrapdocker"]

