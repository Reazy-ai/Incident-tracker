terraform {
  backend "s3" {
    bucket       = "incident-tracker-tfstate"
    key          = "database/rds.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}