FROM cgr.dev/chainguard/wolfi-base

WORKDIR /app/

COPY manpages.tar.gz /app/manpages.tar.gz
RUN tar xf /app/manpages.tar.gz
COPY manpages.index.gz /app/manpages/manpages.index.gz

RUN apk add lighttpd
COPY lighttpd.conf /app/lighttpd.conf
ENTRYPOINT ["lighttpd", "-f", "/app/lighttpd.conf", "-D"]
