data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "incident-tracker-tfstate"
    key    = "networking/vpc.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = "incident-tracker-tfstate"
    key    = "database/rds.tfstate"
    region = "eu-west-1"
  }
}