locals {
  # ensure keys are valid names
  fh_configs = var.firehose_streams
}

terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.25.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# enforce account check at plan time when `allowed_account_id` is set
#resource "null_resource" "account_check" {
#  count = var.allowed_account_id == "" ? 0 : 1

#  precondition {
#    condition     = data.aws_caller_identity.current.account_id == var.allowed_account_id
#   error_message = "Terraform must be executed against AWS account ${var.allowed_account_id}. Current account: ${data.aws_caller_identity.current.account_id}"
#  }
#}

module "firehose" {
  source = "./modules/firehose"
  for_each = local.fh_configs

  # pass object and include name
  config = merge(each.value, { name = each.key })
}
