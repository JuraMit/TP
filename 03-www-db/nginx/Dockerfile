FROM alpine:3.24
# В вузе прокси передаётся через переменную окружения https_proxy (см. README)
ARG https_proxy
ARG http_proxy
RUN apk add --no-cache nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
