ARG LOGPASTE_VERSION=0.3.1
FROM mtlynch/logpaste:${LOGPASTE_VERSION}

RUN apk add --no-cache sqlite

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
