output "stream_arn" {
  description = "ARN of the created Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.this.arn
}

output "stream_name" {
  description = "Name of the created Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.this.name
}

output "role_arn" {
  description = "IAM role ARN used by the Firehose"
  value       = aws_iam_role.firehose_role.arn
}

output "log_group_name" {
  description = "CloudWatch Log Group name (if created)"
  value       = local.cb_logging ? local.log_group_name : ""
}

output "log_stream_name" {
  description = "CloudWatch Log Stream name (if created)"
  value       = local.cb_logging ? local.log_stream_name : ""
}

output "debug_inputs" {
  value = {
    name                        = try(var.config.name, null)
    enable_cloudwatch_logging   = try(var.config.enable_cloudwatch_logging, null)
    retention_in_days           = try(var.config.retention_in_days, null)
    deletion_protection_enabled = try(var.config.deletion_protection_enabled, null)
  }
}


