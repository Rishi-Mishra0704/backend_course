package db

import (
	"log"
	"os"
	"testing"

	"context"

	"github.com/jackc/pgx/v5"
)

const (
	dbSource = "postgresql://root:1111@localhost:5433/simple_bank?sslmode=disable"
)

var testQueries *Queries

func TestMain(m *testing.M) {
	conn, err := pgx.Connect(context.Background(), dbSource)
	if err != nil {
		log.Fatal(err)
	}

	testQueries = New(conn)

	os.Exit(m.Run())
}
