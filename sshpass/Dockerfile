FROM alpine:latest

RUN apk add --no-cache sshpass openssh-client

WORKDIR /app

COPY run.sh /app/run.sh

RUN chmod +x /app/run.sh
ENTRYPOINT ["/bin/sh", "-c", "/app/run.sh"]