postgres:
	docker run --name postgres16 --network bank-network -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=1111 -d postgres:16-alpine

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root simple_bank

opendb:
	docker exec -it postgres16 psql -U root -d simple_bank

dropdb:
	docker exec -it postgres16 dropdb --username=root simple_bank

migrateup:
	migrate -path db/migrations -database "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migrations -database "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migrations -database "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migrations -database "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

startserver:
	go run main.go

mock: 
	mockgen -package mockdb -destination db/mock/store.go github.com/Rishi-Mishra0704/backend_course/db/sqlc Store

.PHONY: createdb postgres dropdb migrateup migratedown sqlc test startserver mock migratedown1 migrateup1