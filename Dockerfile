FROM nginx:alpine

RUN echo '<!DOCTYPE html>\
<html lang="ru">\  
<head>\
<meta charset="UTF-8">\
<title> Hello World </title>\
</head>\
<body>\
</body>\
</html>' > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
