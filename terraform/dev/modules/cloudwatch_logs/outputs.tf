output "log_group_name" {
  value = local.create ? local.log_group_name : ""
}

output "log_stream_name" {
  value = local.create ? local.log_stream_name : ""
}

output "log_group_arn" {
  value = local.create ? try(aws_cloudwatch_log_group.this[0].arn, "") : ""
}

output "log_stream_arn" {
  value = local.create ? try(aws_cloudwatch_log_stream.this[0].arn, "") : ""
}

output "debug_locals" {
  value = {
    create                      = local.create
    log_group_name              = local.log_group_name
    retention_in_days           = local.retention_in_days
    deletion_protection_enabled = local.deletion_protection_enabled
  }
}
