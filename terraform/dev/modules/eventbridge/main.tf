locals {
  cfg = try(var.config, {})
  create = try(local.cfg.create_rule, false)
  rule_name = try(local.cfg.rule_name, "")
  event_pattern = try(local.cfg.event_pattern, null)
  name_suffix = substr(md5(var.target_arn), 0, 8)
}

resource "aws_iam_role" "eb_to_target_role" {
  count = local.create ? 1 : 0
  name  = "eb-to-target-${local.name_suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "events.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eb_to_target_policy" {
  count = local.create ? 1 : 0
  name  = "eb-to-target-policy-${local.name_suffix}"
  role  = aws_iam_role.eb_to_target_role[0].id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["firehose:PutRecord", "firehose:PutRecordBatch"],
        Resource = [var.target_arn]
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "this" {
  count = local.create ? 1 : 0
  name  = local.rule_name != "" ? local.rule_name : "eb-rule-${local.name_suffix}"
  event_pattern = local.event_pattern
}

resource "aws_cloudwatch_event_target" "this" {
  count = local.create ? 1 : 0
  rule = aws_cloudwatch_event_rule.this[0].name
  arn  = var.target_arn
  role_arn = aws_iam_role.eb_to_target_role[0].arn
}
