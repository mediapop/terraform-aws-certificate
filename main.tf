provider "aws" {
  region = "us-east-1"
  alias  = "required-acm-region"
}

resource "aws_acm_certificate" "cert" {
  domain_name               = "${local.domain}"
  subject_alternative_names = "${local.subject_alternative_names}"
  validation_method         = "DNS"
  provider                  = "aws.required-acm-region"
}

data "aws_route53_zone" "zone" {
  count = "${length(local.zones)}"
  name  = "${local.zones[count.index]}"
}

resource "aws_route53_record" "records" {
  // A better option would've been
  // count = "${length(aws_acm_certificate.cert.domain_validation_options)}"
  // but it will error out with a 'value of 'count' cannot be computed' on a clean build.
  count = "${length(local.domains)}"

  name = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_name")}"
  type = "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_type")}"

  // It basically reverses the zone_name from the domain_name, then the zone_id from the zone_name.
  zone_id = "${
    element(matchkeys(
      data.aws_route53_zone.zone.*.id,
      data.aws_route53_zone.zone.*.name,
      local.record_map[lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "domain_name")]
    ), 0)
  }"

  records = [
    "${lookup(aws_acm_certificate.cert.domain_validation_options[count.index], "resource_record_value")}",
  ]

  ttl = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.records.*.fqdn}",
  ]

  provider = "aws.required-acm-region"
}

