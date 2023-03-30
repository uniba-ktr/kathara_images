ARG image=unibaktr/alpine
FROM $image

RUN apk add --no-cache apache2 php php-apache2 && \
    mv /var/www/localhost/htdocs/index.html /var/www/localhost/htdocs/index.bck
COPY apache/index.php /var/www/localhost/htdocs/index.php

EXPOSE 80 443
CMD ["httpd", "-D", "FOREGROUND"]
