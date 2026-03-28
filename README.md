# PAwChO - Laboratorium 5

**Wykonał:** Roman Rybak  
**Grupa:** IO 6.7  

## Cel zadania
Wieloetapowe budowanie obrazów (Multi-stage build). Aplikacja wyświetla:
* Adres IP serwera (generowany dynamicznie przez Nginx SSI)
* Nazwę serwera / hostname (generowany dynamicznie)
* Wersję aplikacji (przekazywaną przez `ARG` podczas budowania)
* Automatyczną kontrolę poprawności działania aplikacji (`HEALTHCHECK`)

## Struktura plików
* `Dockerfile` - plik konfiguracyjny (`scratch`, `nginx:alpine`).
* `alpine-minirootfs-3.21.3-x86_64.tar.gz` - minimalny system plików wykorzystany w etapie builder.

---

## Wyniki działania 
<img width="1246" height="461" alt="image" src="https://github.com/user-attachments/assets/906cda7a-1a88-45df-904c-4b389f91e498" />


### 1. Budowa obrazu z przekazaniem zmiennej VERSION
Użyto polecenia:
```bash
docker build --build-arg VERSION=release-3 -t lab5-web .
<img width="1248" height="561" alt="image" src="https://github.com/user-attachments/assets/82da5518-fb1d-495d-aa5a-4c2180c0fed9" />
