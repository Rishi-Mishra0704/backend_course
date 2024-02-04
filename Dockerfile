# Build stage
FROM golang:1.22rc1-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk --no-cache add curl \
    && curl -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz

# Run stage
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY start.sh .
COPY wait-for.sh .
# Set execute permissions on scripts
RUN chmod +x start.sh wait-for.sh
COPY db/migrations ./migrations

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
