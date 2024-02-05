# Build stage
FROM golang:1.22rc1-alpine3.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk --no-cache add curl \
    && curl -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz

# Explicitly copy the content of app.env into the image
COPY app.env /app/app.env

# Run stage
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate.linux-amd64 ./migrate
ARG DB_SOURCE
ARG SERVER_ADDRESS
ARG TOKEN_SYMMETRIC_KEY
ARG ACCESS_TOKEN_DURATION
ARG AWS_DB

ENV DB_SOURCE=$DB_SOURCE
ENV SERVER_ADDRESS=$SERVER_ADDRESS
ENV TOKEN_SYMMETRIC_KEY=$TOKEN_SYMMETRIC_KEY
ENV ACCESS_TOKEN_DURATION=$ACCESS_TOKEN_DURATION
ENV AWS_DB=$AWS_DB

COPY start.sh .
COPY wait-for.sh .
# Set execute permissions on scripts
RUN chmod +x /app/start.sh
RUN chmod +x /app/wait-for.sh
RUN chmod 600 /app/app.env

COPY db/migrations ./migrations

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
