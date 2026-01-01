variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "firehose_streams" {
  description = "Map of Firehose stream configurations. Key = stream name. Value is an object with stream settings."
  type = map(object({
    s3_bucket_arn             = string
    s3_prefix                 = optional(string)
    error_output_prefix       = optional(string)
    
    enable_cloudwatch_logging = optional(bool)
    cloudwatch_log_group_name = optional(string)
    cloudwatch_log_stream_name = optional(string)
    deletion_protection_enabled = optional(bool)
    retention_in_days      = optional(number)

    eventbridge = optional(object({
      create_rule  = optional(bool)
      rule_name    = optional(string)
      event_pattern = optional(string)
    }))
  }))
  default = {}
}

variable "allowed_account_id" {
  description = "If set, Terraform will enforce execution only in this AWS account ID (plan will fail otherwise). Empty = no check."
  type        = string
}
