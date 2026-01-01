locals {
  cfg             = var.config
  name            = local.cfg.name
  s3_bucket_arn   = local.cfg.s3_bucket_arn
  s3_prefix       = try(local.cfg.s3_prefix, null)

  error_output_prefix = try(local.cfg.error_output_prefix, "")

  cb_logging      = try(local.cfg.enable_cloudwatch_logging, false)
  log_group_name  = try(local.cfg.cloudwatch_log_group_name, "") != "" ? try(local.cfg.cloudwatch_log_group_name, "") : "/aws/kinesisfirehose/${local.name}"
  log_stream_name = try(local.cfg.cloudwatch_log_stream_name, "") != "" ? try(local.cfg.cloudwatch_log_stream_name, "") : "${local.name}-stream"
  retention_in_days       = try(local.cfg.retention_in_days, 30)
  deletion_protection_enabled = try(local.cfg.deletion_protection_enabled, false)
}

resource "aws_iam_role" "firehose_role" {
  name = "fh-role-${local.name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "firehose.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

locals {
  s3_objects = "${local.s3_bucket_arn}/*"
}

module "cw_logs" {
  source = "../cloudwatch_logs"
  count  = local.cb_logging ? 1 : 0

  config = {
    name            = local.name
    log_group_name  = local.log_group_name
    log_stream_name = local.log_stream_name
    create          = true
    retention_in_days = try(local.cfg.retention_in_days, 30)
    deletion_protection_enabled = try(local.cfg.deletion_protection_enabled, false)
  }
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = "fh-policy-${local.name}"
  role = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      [
        {
          Effect = "Allow",
          Action = [
            "s3:PutObject",
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:GetObject"
          ],
          Resource = [local.s3_objects, local.s3_bucket_arn]
        }
      ],
      local.cb_logging ? [
        {
          Effect = "Allow",
          Action = [
            "logs:PutLogEvents",
            "logs:CreateLogStream",
            "logs:DescribeLogStreams"
          ],
          Resource = ["${module.cw_logs[0].log_group_arn}:*"]
        }
      ] : []
    )
  })
}


resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = local.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn         = aws_iam_role.firehose_role.arn
    bucket_arn       = local.s3_bucket_arn
    
    prefix           = local.s3_prefix != "" ? local.s3_prefix : null
    error_output_prefix = try(local.cfg.error_output_prefix, null)
    
    buffering_interval = 300
    buffering_size     = 5
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled        = local.cb_logging
      log_group_name = local.log_group_name
      log_stream_name = local.log_stream_name
    }
  }
}

module "eventbridge" {
  source = "../eventbridge"
  count  = try(local.cfg.eventbridge.create_rule, false) ? 1 : 0
  config = try(local.cfg.eventbridge, {})
  target_arn = aws_kinesis_firehose_delivery_stream.this.arn
}
