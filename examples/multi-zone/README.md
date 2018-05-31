# Request a certificate across multiple zones

```hcl
module "cert" {
  source = "mediapop/certificate/aws"

  domains = {
    "uatdomains.com." = ["terraform-aws-certificate-multi-zone.uatdomains.com"],
    "mediapop.co." = ["terraform-aws-certificate-multi-zone.mediapop.co"]
  }
}
```
