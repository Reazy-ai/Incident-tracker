package database

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

func NewPostgresConnection() (*pgxpool.Pool, error) {

	dsn := BuildDSN()

	var pool *pgxpool.Pool
	var err error

	for i := range 10 {

		config, err := pgxpool.ParseConfig(dsn)
		if err != nil {
			return nil, err
		}

		config.MaxConns = 10
		config.MinConns = 2
		config.MaxConnLifetime = time.Hour

		pool, err = pgxpool.NewWithConfig(context.Background(), config)
		if err == nil {
			err = pool.Ping(context.Background())
			if err == nil {
				log.Println("database connected")
				return pool, nil
			}
		}

		log.Printf("DB not ready, retrying... attempt %d\n", i+1)
		time.Sleep(2 * time.Second)
	}

	return nil, fmt.Errorf("failed to connect to postgres after retries: %w", err)
}
