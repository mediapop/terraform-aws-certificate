# Terraform Certificate

*This terraform module is maintained by [Media Pop](https://www.mediapop.co), a software consultancy. Hire us to solve your DevOps challenges.*

Create and automatically verify a certificate across one or many zones. CloudFront enabled (us-east-1).

# Usage

You can specify as many zones and records as you wish following this simple format:

```hcl
module "cert" {
  source = "mediapop/certificate/aws"

  domains = {
    "zone-name.com." = ["record.zone-name.com"]
    "mediapop.co."   = ["mediapop.co", "*.mediapop.co"]
  }
}

resource "aws_cloudfront_distribution" "redirect" {
  "viewer_certificate" {
    acm_certificate_arn = "${module.cert.arn}"

    // ...
  }

  // ...
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domains | Map of the zone names to records the certificate is for. | map | - | yes |

## Outputs

| Name | Description | Type |
|------|-------------|:----:|
| arn | The certificate arn | string |

## License

MIT
