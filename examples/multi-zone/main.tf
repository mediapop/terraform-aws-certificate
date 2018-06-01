provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 1.21.0"
}

module "cert" {
  source = "../../"

  domains = {
    "uatdomains.com." = ["terraform-aws-certificate-multi-zone.uatdomains.com"]
    "mediapop.co."    = ["terraform-aws-certificate-multi-zone.mediapop.co"]
  }
}
