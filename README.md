# ТП — Docker на Alpine Linux

`03-www-db` — nginx + php-fpm + mariadb + postgres + redis.
Страница `index.php` проверяет подключение ко всем трём БД.

Alpine: пользователь `root`, пароль `student`, хост `semga`.

## Запуск в вузе (через прокси)

```
export http_proxy=http://172.27.100.5:4444
export https_proxy=http://172.27.100.5:4444

apk add git
git clone https://github.com/JuraMit/TP /srv/tp
sh /srv/tp/scripts/install.sh
sh /srv/tp/scripts/proxy-on.sh

cd /srv/tp/03-www-db
docker compose up -d --build
```

Если репозиторий уже скачан: `cd /srv/tp && git pull`, затем `proxy-on.sh` и `docker compose up -d --build`.

Проверка: `curl localhost` или в браузере `http://<ip виртуалки>` (ip смотреть командой `ip a`).

## Запуск дома (без прокси)

```
sh /srv/tp/scripts/proxy-off.sh
unset http_proxy https_proxy no_proxy
cd /srv/tp/03-www-db && docker compose up -d --build
```

VirtualBox, проброс портов: `2222 → 22` (ssh), `8080 → 80` (сайт).
`ssh -p 2222 root@localhost`, сайт — http://localhost:8080

## Остановка

```
docker compose down
```
