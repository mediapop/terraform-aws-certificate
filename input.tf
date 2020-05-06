variable "domains" {
  type        = map(list(string))
  description = "A map {\"zone.com.\" = [\"zone.com\",\"www.zone.com\"],\"foo.com\" = [\"foo.com\"] } of domains."
}

locals {
  zones = keys(var.domains)

  // We can't get the first index of an empty array, so we add a blank string element as a default so it doesn't blow
  // up when the domain map is empty.
  domain = element(concat(local.domains, local.EMPTY_LIST), 0)

  record_map = transpose(var.domains)
  domains    = compact(concat(keys(local.record_map), local.EMPTY_LIST))

  // We use this empty list to work around HCL limitations.
  EMPTY_LIST = [""]

  // *.example.org and example.org only needs 1 validation record. We need to unduplicate those domains
  // If domains {} is empty the list will become [""], so we need to compact it.
  validations_needed = length(compact(distinct(split(",", replace(join(",", local.domains), "*.", "")))))

  // Because of HCL limitations we can't slice an empty array because it won't understand it's internally a string
  // type.
  // So we add an empty element of type string which we then compact away into an empty array.
  subject_alternative_names = compact(slice(concat(local.domains, local.EMPTY_LIST), 1, length(local.domains) + 1))
}
