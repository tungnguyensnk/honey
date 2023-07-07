FROM ubuntu:jammy-20230605

RUN apt-get update && apt-get install -y \
    redsocks \
    iptables \
    curl \
#    psmisc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY honeygain /app/honeygain
COPY ./libhg.so* /usr/lib/
ENV LD_LIBRARY_PATH=/usr/lib
COPY run.sh /app/run.sh

RUN chmod +x /app/honeygain
RUN chmod +x /app/run.sh
ENTRYPOINT ["/bin/sh", "-c", "/app/run.sh"]
