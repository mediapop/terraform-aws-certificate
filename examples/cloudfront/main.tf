provider "aws" {
  region = "ap-southeast-1"
}

locals {
  domain = "terraform-aws-certificate.uatdomains.com"

  domains = {
    "uatdomains.com." = [local.domain]
  }
}

module "cert" {
  source = "../../"

  domains = local.domains
}

resource "random_string" "redirect-bucket" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "redirect" {
  bucket = random_string.redirect-bucket.result

  website {
    redirect_all_requests_to = "https://mediapop.co"
  }
}

resource "aws_cloudfront_distribution" "redirect" {
  origin {
    domain_name = aws_s3_bucket.redirect.website_endpoint
    origin_id   = "website"

    custom_origin_config {
      http_port  = "80"
      https_port = "443"

      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = [
    local.domain,
  ]

  default_cache_behavior {
    allowed_methods = [
      "HEAD",
      "GET",
    ]

    cached_methods = [
      "HEAD",
      "GET",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    target_origin_id       = "website"
    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.cert.arn
    ssl_support_method  = "sni-only"
  }
}

module "dns" {
  source               = "mediapop/route53-alias/aws"
  version              = ">= 1.2.0"
  domains              = local.domains
  alias_hosted_zone_id = aws_cloudfront_distribution.redirect.hosted_zone_id
  alias_domain_name    = aws_cloudfront_distribution.redirect.domain_name
}
