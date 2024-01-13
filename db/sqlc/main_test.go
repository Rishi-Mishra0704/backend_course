package db

import (
	"log"
	"os"
	"testing"

	"context"

	"github.com/Rishi-Mishra0704/backend_course/util"
	"github.com/jackc/pgx/v5/pgxpool"
)

var testQueries *Queries
var testDB *pgxpool.Pool

func TestMain(m *testing.M) {
	var err error
	config, err := util.LoadConfig("../../")
	if err != nil {
		log.Fatal("Cannot load config", err)
	}
	testDB, err = pgxpool.New(context.Background(), config.DBSource)
	if err != nil {
		log.Fatal(err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
