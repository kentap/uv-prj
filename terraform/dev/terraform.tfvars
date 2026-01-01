# terraform.tfvars - example values for this workspace
allowed_account_id = "944249714029"

firehose_streams = {
  my-stream-01 = {
    s3_bucket_arn = "arn:aws:s3:::data-lake-20260101"
    s3_prefix     = "firehose/data1"
    enable_cloudwatch_logging = true
    cloudwatch_log_group_name  = "/aws/kinesisfirehose/my-stream-01"
    cloudwatch_log_stream_name = "fh-ops-data1"

    prefix="my-stream-01/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    # optional: write failed records to S3 under this prefix
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    
    s3_backup_mode = "Enabled"
    retention_in_days = 60
    deletion_protection_enabled = true
    
    eventbridge = {
      create_rule = true
      rule_name = "eb-to-fh-my-stream-01"
      event_pattern = <<EOF
{ "source": ["custom.app"] }
EOF
    }
  }

  my-stream-02 = {
    s3_bucket_arn = "arn:aws:s3:::data-lake-20260101"
    s3_prefix     = "firehose/data2"
    # CloudWatch logging disabled
    enable_cloudwatch_logging = true
    cloudwatch_log_group_name  = "/aws/kinesisfirehose/my-stream-02"
    cloudwatch_log_stream_name = "fh-ops-data2"
    prefix="my-stream-02/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    retention_in_days = 180
    # No EventBridge rule
  }

  my-stream-03 = {
    s3_bucket_arn = "arn:aws:s3:::data-lake-20260101"
    s3_prefix     = "firehose/data3"
    enable_cloudwatch_logging = true
    cloudwatch_log_group_name  = "/aws/kinesisfirehose/my-stream-03"
    cloudwatch_log_stream_name = "fh-ops-data3"
    error_output_prefix = "errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    deletion_protection_enabled = true
    # Use default log group and stream names
    # No EventBridge rule
  }
}
