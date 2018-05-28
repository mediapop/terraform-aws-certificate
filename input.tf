variable "domains" {
  type        = "map"
  description = "A map {\"zone.com.\" = [\"zone.com\",\"www.zone.com\"],\"foo.com\" = [\"foo.com\"] } of domains."
}

locals {
  zones                     = "${keys(var.domains)}"
  domain                    = "${local.domains[0]}"
  record_map                = "${transpose(var.domains)}"
  domains                   = "${keys(local.record_map)}"
  subject_alternative_names = "${slice(local.domains, 1, length(local.domains))}"
}
