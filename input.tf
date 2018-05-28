variable "domains" {
  type        = "map"
  description = "A map {\"zone.com.\" = [\"zone.com\",\"www.zone.com\"],\"foo.com\" = [\"foo.com\"] } of domains."
}

locals {
  zones      = "${keys(var.domains)}"
  domain     = "${local.domains[0]}"
  record_map = "${transpose(var.domains)}"
  domains    = "${keys(local.record_map)}"

  // *.example.org and example.org only needs 1 validation record. We need to unduplicate those domains
  validations_needed        = "${length(distinct(split(",", replace(join(",", local.domains), "*.", ""))))}"
  subject_alternative_names = "${slice(local.domains, 1, length(local.domains))}"
}
