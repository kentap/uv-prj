variable "config" {
  description = "EventBridge config object. Fields: create_rule (optional bool), rule_name (optional string), event_pattern (optional string)"
  type = object({
    create_rule   = optional(bool)
    rule_name     = optional(string)
    event_pattern = optional(string)
  })
}

variable "target_arn" {
  description = "ARN of the target resource (e.g., Firehose delivery stream)"
  type        = string
}
