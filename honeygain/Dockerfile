FROM alpine:latest
RUN apk update && apk add --no-cache \
    curl \
    iptables \
    redsocks \
    gcompat \
    libstdc++ \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY honeygain /app/honeygain
COPY ./libhg.so* /usr/lib/
ENV LD_LIBRARY_PATH=/usr/lib

RUN chmod +x /app/honeygain
ENTRYPOINT ["/bin/sh"]