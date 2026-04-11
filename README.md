# PAwChO - Laboratorium 6

**Wykonał:** Roman Rybak  
**Grupa:** IO 6.7  

---

## Cel zadania

Zaawansowane mechanizmy budowania obrazów Docker (BuildKit, SSH, GHCR).  
Celem było skonfigurowanie procesu budowania obrazu z wykorzystaniem:
- BuildKit
- SSH 
- integracji z GitHub Container Registry (GHCR)

---

## Kluczowe funkcjonalności

* Bezpieczne klonowanie repozytorium (`--mount=type=ssh`)
* Multi-stage build (cloner → builder → final)
* Publikacja obrazu do GHCR
* Uruchomienie i test aplikacji lokalnie

---

##  Dockerfile – konfiguracja aplikacji

```dockerfile
# syntax=docker/dockerfile:1.2

FROM alpine/git AS cloner
WORKDIR /repo
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:RomanFisher/pawcho6.git .

FROM alpine AS builder
COPY --from=cloner /repo/alpine-minirootfs-3.21.3-x86_64.tar.gz /
ARG VERSION=v1.0.0
WORKDIR /app

RUN echo "<!DOCTYPE html><html><body>" > index.html && \
    echo "<h2>PAwChO - Laboratorium 6</h2>" >> index.html && \
    echo "<h3>Wykonal: Roman Rybak, Grupa: IO 6.7</h3>" >> index.html && \
    echo "<hr>" >> index.html && \
    echo "<p>Wersja aplikacji: ${VERSION}</p>" >> index.html && \
    echo "<p>Hostname serwera: </p>" >> index.html && \
    echo "<p>Adres IP serwera: </p>" >> index.html && \
    echo "</body></html>" >> index.html

FROM nginx:alpine

LABEL org.opencontainers.image.source="https://github.com/RomanFisher/pawcho6"
LABEL org.opencontainers.image.description="Aplikacja z laboratorium 6 zbudowana przez BuildKit i SSH"

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
```


---

## Budowanie obrazu (Docker BuildKit)

<img width="1176" height="231" alt="image" src="https://github.com/user-attachments/assets/dfe32823-ed93-4ed2-b84a-fb73b31b4859" />

```bash
docker build --ssh default \
  --build-arg VERSION=lab6-final \
  -t ghcr.io/romanfisher/pawcho6:lab6 .
```

---

## Publikacja obrazu w GHCR

<img width="889" height="338" alt="image" src="https://github.com/user-attachments/assets/357b8734-7ce6-463c-8abf-ec025d9e0690" />

```bash
docker push ghcr.io/romanfisher/pawcho6:lab6
```


---

## Uruchomienie kontenera

<img width="974" height="69" alt="image" src="https://github.com/user-attachments/assets/b41730ff-4a9a-4e7d-b5b8-d5a81c7098d9" />
<img width="570" height="261" alt="image" src="https://github.com/user-attachments/assets/31eefea0-76ef-48b3-b705-c99f3f688441" />


```bash
docker run -d -p 8080:80 --name lab6_final ghcr.io/romanfisher/pawcho6:lab6
```


---

## Widoczność w GitHub Packages

Obraz został poprawnie opublikowany i jest dostępny w GHCR.

<img width="1349" height="926" alt="image" src="https://github.com/user-attachments/assets/9d73d53f-134c-4d16-b32c-4ac533531759" />

---

## Linki do zasobów

- Repozytorium GitHub:  
  https://github.com/RomanFisher/pawcho6

- Pakiet w GHCR:  
  https://github.com/RomanFisher/pawcho6/pkgs/container/pawcho6
