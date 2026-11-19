# ЛР 4. Гипотеза Коллатца + Redis

Для каждого числа от 1 до N считается, за сколько шагов оно дойдёт до 1
(чётное → n/2, нечётное → 3n+1). Время считается три раза: без Redis,
с Redis на пустой базе и с Redis на заполненной базе.

## Запуск на Alpine

В вузе сначала включить прокси:

```
export http_proxy=http://172.27.100.5:4444
export https_proxy=http://172.27.100.5:4444
```

Установка Node.js и библиотеки redis (один раз):

```
apk add nodejs npm
cd /srv/tp && git pull
cd 04-redis-collatz/app
npm install
cd ..
```

Запуск:

```
docker compose run --rm app
```

Другое количество чисел:

```
N=1000000 docker compose run --rm app
```

Остановить Redis:

```
docker compose down
```
