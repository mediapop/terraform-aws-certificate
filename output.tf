output "arn" {
  value       = "${element(concat(aws_acm_certificate_validation.cert_validation.*.certificate_arn, local.EMPTY_LIST), 0)}"
  description = "The certificate ARN. If the domains map is empty, it will be set to an empty string."
}
