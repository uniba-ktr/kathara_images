ARG image=unibaktr/alpine
FROM golang:alpine AS binary
ENV GO111MODULE=off
ADD ./whoami /app
WORKDIR /app
RUN go build -o http

FROM $imag
WORKDIR /app
ENV PORT 80
EXPOSE 80
COPY --from=binary /app/http /bin
CMD ["http"]
