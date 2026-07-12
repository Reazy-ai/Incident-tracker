terraform {
  backend "s3" {
    bucket       = "incident-tracker-tfstate"
    key          = "iam/iam.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}