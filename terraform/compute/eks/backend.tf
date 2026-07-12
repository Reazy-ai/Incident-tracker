terraform {
  backend "s3" {
    bucket         = "incident-tracker-tfstate"
    key            = "compute/eks.tfstate"
    region         = "eu-west-1"
    use_lockfile   = true
  }
}