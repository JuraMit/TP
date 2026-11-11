# ТП — Docker на Alpine Linux

```
/srv/tp/
  01-nginx-hello/        Dockerfile — nginx со страницей Hello World
  03-www-db/             сайт: nginx + php-fpm + mariadb + postgres + redis
    docker-compose.yml
    nginx/   Dockerfile, conf/   (монтируется в /etc/nginx)
    php-fpm/ Dockerfile, conf/   (монтируется в /etc/php85)
    www/     index.php — проверка подключения ко всем БД
  scripts/
    install.sh    установка docker, docker compose, python3, git
    proxy-on.sh   включить прокси (вуз)
    proxy-off.sh  выключить прокси (дом)
```

Сервисы в `03-www-db/docker-compose.yml`:

| сервис   | образ               | что делает                         |
|----------|---------------------|------------------------------------|
| nginx    | сборка `./nginx`    | веб-сервер, порт 80                |
| php      | сборка `./php-fpm`  | php-fpm 8.5 (mysqli, pdo_pgsql, redis) |
| db-mysql | mariadb             | пароль root: `secret`              |
| db-pgsql | postgres            | пароль postgres: `secret`          |
| db-redis | redis               |                                    |

Пароль root на виртуалке: `student`, имя хоста: `semga`.

---

## Дома (VirtualBox, всё уже настроено)

В VirtualBox настроен проброс портов (Настроить → Сеть → Проброс портов):
- `2222 → 22` — ssh
- `8080 → 80` — сайт

Подключение из Windows (cmd / PowerShell / Терминал):
```
ssh -p 2222 root@localhost
```
Сайт: http://localhost:8080

Запуск / остановка проекта:
```
cd /srv/tp/03-www-db
docker compose up -d --build     # собрать и запустить
docker ps                        # должно быть 5 контейнеров
docker compose down              # остановить
```

---

## В вузе (интернет только через прокси 172.27.100.5:4444)

### Вариант А — новая чистая Alpine (после `setup-alpine`)
```
export http_proxy=http://172.27.100.5:4444
export https_proxy=http://172.27.100.5:4444

apk add git
git clone https://github.com/JuraMit/TP /srv/tp
sh /srv/tp/scripts/install.sh          # docker, compose, python3

sh /srv/tp/scripts/proxy-on.sh         # прокси для docker-демона + на будущее
. /etc/profile.d/proxy.sh

cd /srv/tp/03-www-db
docker compose up -d --build
```

### Вариант Б — та же виртуалка, что дома
```
sh /srv/tp/scripts/proxy-on.sh
. /etc/profile.d/proxy.sh
cd /srv/tp && git pull
cd 03-www-db && docker compose up -d --build
```

Проверка: открыть в браузере `http://<ip-виртуалки>/` (ip — `ip a`, интерфейс eth0)
или прямо на виртуалке `curl localhost`. На странице должны быть три зелёные галочки:
MariaDB, PostgreSQL, Redis.

Дома прокси нужно выключить, иначе ничего не скачается:
```
sh /srv/tp/scripts/proxy-off.sh
unset http_proxy https_proxy no_proxy
```

### Как работает прокси
- `apk`, `git`, `curl` берут прокси из переменных `http_proxy` / `https_proxy`.
- Docker-демон (скачивание образов mariadb, postgres, redis, alpine) берёт прокси
  из `/etc/docker/daemon.json` — его пишет `proxy-on.sh` и перезапускает docker.
- Внутри `docker build` прокси передаётся как build-аргумент `https_proxy`
  (в `docker-compose.yml`: `args: - https_proxy`), поэтому `apk add` в Dockerfile
  тоже идёт через прокси. Это то же самое, что у преподавателя
  `RUN https_proxy=http://172.27.100.5:4444 apk add ...`, только без жёстко
  прописанного адреса.

### Сохранить изменения в GitHub (с виртуалки)
```
cd /srv/tp
git config --global user.name "JuraMit"
git config --global user.email "почта"
git add -A && git commit -m "что изменил"
git push        # логин GitHub + Personal Access Token вместо пароля
```
