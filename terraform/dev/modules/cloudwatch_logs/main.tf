locals {
  cfg = var.config
  name = local.cfg.name

  log_group_name = try(local.cfg.log_group_name, "") != "" ? try(local.cfg.log_group_name, "") : "/aws/kinesisfirehose/${local.name}"
  log_stream_name = try(local.cfg.log_stream_name, "") != "" ? try(local.cfg.log_stream_name, "") : "${local.name}-stream"
  
  create = try(local.cfg.create, true)
  
  retention_in_days = try(local.cfg.retention_in_days, 30)
  deletion_protection_enabled = try(local.cfg.deletion_protection_enabled, false)
}

resource "aws_cloudwatch_log_group" "this" {
  count = local.create ? 1 : 0

  name                        = local.log_group_name
  retention_in_days           = local.retention_in_days
  deletion_protection_enabled = local.deletion_protection_enabled
}

resource "aws_cloudwatch_log_stream" "this" {
  count = local.create ? 1 : 0

  name           = local.log_stream_name
  log_group_name = aws_cloudwatch_log_group.this[0].name
}