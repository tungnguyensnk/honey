FROM alpine:latest
RUN apk update && apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/testing \
    curl \
    iptables \
    redsocks \
    mitmproxy \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY mitm.py /app/mitm.py

RUN chmod +x /app/mitm.py
ENTRYPOINT ["/bin/sh"]
