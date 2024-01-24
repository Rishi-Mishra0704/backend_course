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
# Copy from the builder stage, including app.env
COPY --from=builder /app/main .
COPY --from=builder /app/app.env .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
COPY --from=builder /app/start.sh .
COPY --from=builder /app/wait-for.sh .
COPY --from=builder /app/db/migrations ./migrations

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
