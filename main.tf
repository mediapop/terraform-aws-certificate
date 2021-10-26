provider "aws" {
  region = "us-east-1"
  alias  = "acm"
}

resource "aws_acm_certificate" "cert" {
  count                     = local.certificates_issued
  domain_name               = local.domain
  subject_alternative_names = local.subject_alternative_names
  validation_method         = "DNS"
  provider                  = aws.acm

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  for_each = var.domains
  name     = each.key
}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.0.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      record = dvo.resource_record_value
      type  = dvo.resource_record_type

      zone_id = data.aws_route53_zone.zone[local.host_to_zone[dvo.domain_name]].zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count           = local.certificates_issued
  certificate_arn = aws_acm_certificate.cert.0.arn

  validation_record_fqdns = [
    for record in aws_route53_record.record : record.fqdn
  ]

  provider = aws.acm
}
