variable "config" {
  description = "CloudWatch logs configuration object. Fields: name, log_group_name (optional), log_stream_name (optional), create (optional), retention_in_days (optional)"
  type = object({
    name               = string
    log_group_name     = optional(string)
    log_stream_name    = optional(string)
    create             = optional(bool)
    retention_in_days  = optional(number)
    deletion_protection_enabled = optional(bool)
  })
}
