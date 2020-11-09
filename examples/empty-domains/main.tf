provider "aws" {
  region = "ap-southeast-1"
}

module "cert" {
  source = "../../"

  domains = {}
}
