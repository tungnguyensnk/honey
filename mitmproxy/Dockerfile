FROM mitmproxy/mitmproxy:dev

RUN apt-get update && apt-get install -y \
    redsocks \
    iptables \
    curl \
#    psmisc \
    && rm -rf /var/lib/apt/lists/* \

WORKDIR /app

COPY mitm.py /app/mitm.py
COPY run.sh /app/run.sh

RUN chmod +x /app/mitm.py
RUN chmod +x /app/run.sh
ENTRYPOINT ["/bin/sh", "-c", "/app/run.sh"]
