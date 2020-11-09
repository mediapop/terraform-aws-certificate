output "arn" {
  value       = try(aws_acm_certificate_validation.cert_validation.0.certificate_arn, null)
  description = "The certificate ARN. If the domains map is empty, it will be set to null."
}
