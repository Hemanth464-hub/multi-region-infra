terraform {
  backend "gcs" {
    bucket = "tfstate-clean-trees"
    prefix = "shopsphere/prod"
  }
}
