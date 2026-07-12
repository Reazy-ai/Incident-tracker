resource "aws_secretsmanager_secret" "db" {
  name = "incident-db-credentials-2"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}