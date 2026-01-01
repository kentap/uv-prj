variable "config" {
  description = "Firehose configuration object. Required: name, s3_bucket_arn. Optional: s3_prefix, enable_cloudwatch_logging, cloudwatch_log_group_name, cloudwatch_log_stream_name, kms_key_arn, eventbridge"
  type = object({
    name                      = string
    s3_bucket_arn             = string
    s3_prefix                 = optional(string)
    error_output_prefix       = optional(string)
    role_arn                  = optional(string)
    enable_cloudwatch_logging = optional(bool)
    cloudwatch_log_group_name = optional(string)
    cloudwatch_log_stream_name = optional(string)
    retention_in_days           = optional(number)
    deletion_protection_enabled = optional(bool)
    
    # eventbridge: optional nested object passed to ../eventbridge module
    eventbridge = optional(object({
      create_rule   = optional(bool)
      rule_name     = optional(string)
      event_pattern = optional(string)
    }))
    
  })
}
