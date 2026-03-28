
FROM scratch AS builder

ADD alpine-minirootfs-3.21.3-x86_64.tar.gz /

ARG VERSION=v1.0.0

WORKDIR /app

RUN echo "<!DOCTYPE html><html><body>" > index.html && \
    echo "<h2>PAwChO - Laboratorium 5</h2>" >> index.html && \
    echo "<h3>Wykonal: Roman Rybak, Grupa: IO 6.7</h3>" >> index.html && \
    echo "<hr>" >> index.html && \
    echo "<p>Wersja aplikacji: ${VERSION}</p>" >> index.html && \
    echo "<p>Hostname serwera: <!--# echo var=\"hostname\" --></p>" >> index.html && \
    echo "<p>Adres IP serwera: <!--# echo var=\"server_addr\" --></p>" >> index.html && \
    echo "</body></html>" >> index.html


FROM nginx:alpine

RUN apk add --update curl && rm -rf /var/cache/apk/*

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

RUN echo "server {" > /etc/nginx/conf.d/default.conf && \
    echo "    listen 80;" >> /etc/nginx/conf.d/default.conf && \
    echo "    location / {" >> /etc/nginx/conf.d/default.conf && \
    echo "        root /usr/share/nginx/html;" >> /etc/nginx/conf.d/default.conf && \
    echo "        index index.html;" >> /etc/nginx/conf.d/default.conf && \
    echo "        ssi on;" >> /etc/nginx/conf.d/default.conf && \
    echo "    }" >> /etc/nginx/conf.d/default.conf && \
    echo "}" >> /etc/nginx/conf.d/default.conf

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80