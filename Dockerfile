FROM cgr.dev/chainguard/wolfi-base

WORKDIR /app/

COPY manpages.tar.gz /app/manpages/manpages.tar.gz
COPY manpages.index.gz /app/manpages/manpages.index.gz
RUN tar xf /app/manpages/manpages.tar.gz -C /app/manpages/

RUN apk add lighttpd
COPY lighttpd.conf /app/lighttpd.conf
ENTRYPOINT ["lighttpd", "-f", "/app/lighttpd.conf", "-D"]
