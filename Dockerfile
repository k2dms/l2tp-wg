FROM alpine:latest

LABEL maintainer="k2dms" \
      description="Minimal silent proxy container" \
      vendor="STL" \
      version="1.0"

RUN apk --no-cache add tinyproxy

# Настройка tinyproxy
RUN sed -i 's/^Port 8888/Port 8089/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/^LogLevel Info/LogLevel Critical/' /etc/tinyproxy/tinyproxy.conf && \
    echo "DisableViaHeader Yes" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "MaxClients 50" >> /etc/tinyproxy/tinyproxy.conf && \
    echo "Allow 0.0.0.0/0" >> /etc/tinyproxy/tinyproxy.conf

EXPOSE 8089

CMD ["tinyproxy", "-d"]
