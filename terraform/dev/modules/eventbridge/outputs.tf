output "rule_name" {
  value = length(aws_cloudwatch_event_rule.this) > 0 ? aws_cloudwatch_event_rule.this[0].name : ""
}

output "role_arn" {
  value = length(aws_iam_role.eb_to_target_role) > 0 ? aws_iam_role.eb_to_target_role[0].arn : ""
}
