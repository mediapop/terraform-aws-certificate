variable "domains" {
  type        = map(list(string))
  description = "A map {\"zone.com.\" = [\"zone.com\",\"www.zone.com\"],\"foo.com\" = [\"foo.com\"] } of domains."
}

locals {
  host_to_zone = {
    for host, values in transpose(var.domains) : host => values[0]
  }

  zones = keys(var.domains)

  domains = keys(transpose(var.domains))

  domain                    = try(element(local.domains, 0), null)
  subject_alternative_names = try(slice(local.domains, 1, length(local.domains)), [])
  certificates_issued       = length(local.domains) > 0 ? 1 : 0
}
