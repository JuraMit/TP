FROM alpine:3.24
ARG https_proxy
ARG http_proxy
RUN apk add --no-cache nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
