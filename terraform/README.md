# Firehose Terraform module (example)

概要: 再利用可能な Kinesis Data Firehose 配置モジュールを提供します。

ルートで複数のストリームを `firehose_streams` という map(object) 変数で定義し、`for_each` によりモジュールを複数作成できます。

例 (terraform/terraform.tfvars または CLI 変数):

```
firehose_streams = {
  my-stream-01 = {
    s3_bucket_arn = "arn:aws:s3:::existing-bucket-name"
    s3_prefix     = "incoming/"
    enable_cloudwatch_logging = true
    # optional: cloudwatch_log_group_name = "/aws/kinesisfirehose/custom"
    eventbridge = {
      create_rule = true
      rule_name = "eb-to-fh-my-stream-01"
      event_pattern = <<EOF
{ "source": ["custom.app"] }
EOF
    }
  }
}
```

使い方:

1. `cd terraform`
2. `terraform init`
3. `terraform plan -var-file=terraform.tfvars` または `terraform apply -var-file=terraform.tfvars`

注意:
- S3 バケットは事前に存在するものを指定してください。
- モジュールは CloudWatch Log Group と Log Stream を自動作成します。
- EventBridge へ送る場合は `eventbridge.create_rule = true` を指定してください（モジュールが EventBridge Rule と Target を作成します）。
