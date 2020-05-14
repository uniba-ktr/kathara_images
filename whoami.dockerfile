FROM golang:alpine AS binary
ADD ./whoami /app
WORKDIR /app
RUN go build -o http

FROM alpine
WORKDIR /app
ENV PORT 80
EXPOSE 80
COPY --from=binary /app/http /bin
CMD ["http"]
