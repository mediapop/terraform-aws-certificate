provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 1.21.0"
}

module "cert" {
  source = "../../"

  domains = {}
}
