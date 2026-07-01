ARG LOGPASTE_VERSION=0.3.1
FROM mtlynch/logpaste:${LOGPASTE_VERSION}

RUN apk add --no-cache sqlite

COPY docker-entrypoint /app/docker-entrypoint
RUN chmod +x /app/docker-entrypoint

ENTRYPOINT ["/app/docker-entrypoint"]
