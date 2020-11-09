# Request a certificate across multiple zones

Pass in multiple zones and names it will provision a single certificate across all of them.

```hcl
module "cert" {
  source = "mediapop/certificate/aws"

  domains = {
    "uatdomains.com." = ["terraform-aws-certificate-multi-zone.uatdomains.com"],
    "mediapop.co."    = ["terraform-aws-certificate-multi-zone.mediapop.co"]
  }
}
```
