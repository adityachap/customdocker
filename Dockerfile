FROM debian
RUN mkdir -p /hyperledger
RUN chgrp -R 0 /hyperledger && chmod -R g=u /hyperledger
WORKDIR /hyperledger