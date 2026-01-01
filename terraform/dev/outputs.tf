output "firehose_stream_arns" {
  description = "Map of created Firehose delivery stream ARNs"
  value = { for k, m in module.firehose : k => m.stream_arn }
}

output "firehose_log_groups" {
  description = "Map of CloudWatch log group names for each stream (if created)"
  value = { for k, m in module.firehose : k => m.log_group_name }
}

output "debug_firehose_inputs" {
  value = { for k, m in module.firehose : k => m.debug_inputs }
}

output "debug_cw_logs_locals" {
  value = {
    for k, m in module.firehose :
    k => (try(m.cw_logs[0].debug_locals, null))
  }
}

