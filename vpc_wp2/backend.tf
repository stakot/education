terraform {
  backend "s3" {
    bucket = "sko.terraform"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}