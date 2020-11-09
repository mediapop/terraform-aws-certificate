provider "aws" {
  region = "ap-southeast-1"
}

module "cert" {
  source = "../../"

  domains = {
    "uatdomains.com." = ["terraform-aws-certificate-multi-zone.uatdomains.com"]
    "mediapop.co."    = ["terraform-aws-certificate-multi-zone.mediapop.co"]
  }
}

output "test" {
  value = module.cert.arn
}
