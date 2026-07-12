package database

import (
	"net"
	"net/url"
	"os"
)

func BuildDSN() string {
	host := os.Getenv("DB_HOST")
	port := os.Getenv("DB_PORT")
	user := os.Getenv("DB_USER")
	password := os.Getenv("DB_PASSWORD")
	dbname := os.Getenv("DB_NAME")

	u := &url.URL{
		Scheme: "postgres",
		User:   url.UserPassword(user, password),
		Host:   net.JoinHostPort(host, port),
		Path:   dbname,
	}

	q := u.Query()
	q.Set("sslmode", "require")
	u.RawQuery = q.Encode()

	return u.String()
}
