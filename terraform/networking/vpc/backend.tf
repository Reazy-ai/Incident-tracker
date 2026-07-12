terraform {
  backend "s3" {
    bucket         = "incident-tracker-tfstate"
    key            = "networking/vpc.tfstate"
    region         = "eu-west-1"
    use_lockfile   = true
  }
}