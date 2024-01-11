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
var testDB *pgx.Conn

func TestMain(m *testing.M) {
	var err error
	testDB, err = pgx.Connect(context.Background(), dbSource)
	if err != nil {
		log.Fatal(err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
