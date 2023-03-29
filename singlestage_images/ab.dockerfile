ARG image=unibaktr/alpine
FROM $image

RUN apk add --no-cache apache2-utils
