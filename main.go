package main

import (
	"context"
	"log"

	"github.com/Rishi-Mishra0704/backend_course/api"
	db "github.com/Rishi-Mishra0704/backend_course/db/sqlc"
	"github.com/jackc/pgx/v5/pgxpool"
)

const (
	dbSource = "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable"
	port     = "0.0.0.0:8080"
)

func main() {
	conn, err := pgxpool.New(context.Background(), dbSource)
	if err != nil {
		log.Fatal(err)
	}
	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(port)
	if err != nil {
		log.Fatal("cannot start server")
	}
}
