# CloudFront Example

The full example sets up a 301 redirect with cloudfront terminating SSL.

```hcl
module "cert" {
  source = "mediapop/certificate/aws"

  domains = {
    "uatdomains.com." = ["terraform-aws-certificate.uatdomains.com"],
  }
}

resource "aws_cloudfront_distribution" "redirect" {
  // ...
  viewer_certificate {
    acm_certificate_arn = module.cert.arn
    ssl_support_method  = "sni-only"
  }
}
```
