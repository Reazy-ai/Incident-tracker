resource "aws_security_group" "rds" {
  name        = "incident-rds-sg"
  description = "RDS Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name = "incident-db-subnet-group"

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
}

resource "random_password" "db_password" {
  length  = 24
  special = true
  override_special = "!#$%^&*()-_=+[]{}:;,.?"
}

resource "aws_db_instance" "postgres" {
  identifier = "incident-db"

  engine         = "postgres"
  engine_version = "17"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "incident_tracker"
  username = "postgres"
  password = random_password.db_password.result

  publicly_accessible = false

  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = 1

  deletion_protection = false
}