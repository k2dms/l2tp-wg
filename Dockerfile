FROM ubuntu:22.04

LABEL maintainer="k2dms" \
      description="Silent Squid Proxy" \
      vendor="HOME" \
      version="1.0"

RUN apt-get update && \
    apt-get install -y squid && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY squid.conf /etc/squid/squid.conf

EXPOSE 8089

CMD ["squid", "-N", "-f", "/etc/squid/squid.conf"]
