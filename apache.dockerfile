FROM unibaktr/alpine

RUN apk add --no-cache apache2
EXPOSE 80 443
CMD ["httpd", "-D", "FOREGROUND"]
