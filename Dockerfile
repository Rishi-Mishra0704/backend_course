# build stage
FROM golang:1.22rc1-alpine3.19 As builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#Run Stage
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8080
CMD [ "/app/main" ]