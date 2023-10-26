<!-- BEGIN_TF_DOCS -->
# terraform-aws-datadog-integration-streaming

GitHub: [StratusGrid/terraform-aws-datadog-integration-streaming](https://github.com/StratusGrid/terraform-aws-datadog-integration-streaming)

## Example

Multi-region Example utilizing both the integration module to make the account level integration in DataDog and the metrics streaming module to create the firehose and metrics stream in each region.
```hcl
# Standard Variables and Locals
variable "env_name" {
  description = "Environment name string to be used for decisions and name generation"
  type        = string
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type        = string
}

variable "name_suffix" {
  description = "String to append to object names. This is optional, so start with dash if using."
  type        = string
  default     = ""
}

variable "source_repo" {
  description = "name of repo which holds this code"
  type        = string
}

locals {
  name_suffix = "${var.name_suffix}-${var.env_name}"
}

locals {
  common_tags = {
    Environment = var.env_name
    #   Application = var.application_name
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
    SourceRepo  = var.source_repo
  }
}

# Solution Specific Variables and Locals
variable "datadog_api_secret_arn" {
  description = "The ARN of the secret which has the DataDog api key, app key, and api url. Value should be in json format with keys datadog_api_key, datadog_app_key, datadog_api_url, and datadog_firehose_delivery_stream_url "
  type        = string
}

locals {
  datadog_host_tags = [
    "environment:${var.env_name}",
    "account-name:${data.aws_iam_account_alias.current.account_alias}"
  ]
}

# Providers
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  default_tags {
    tags = merge(
      local.common_tags
    )
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "eu-west-2"
  alias  = "eu-west-2"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ca-central-1"
  alias  = "ca-central-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "sa-east-1"
  alias  = "sa-east-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eu-central-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "ap-southeast-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "ap-southeast-2"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "ap-northeast-1"
  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  region = "ap-northeast-2"
  alias  = "ap-northeast-2"
  default_tags {
    tags = local.common_tags
  }
}

# Data Calls
data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_secretsmanager_secret_version" "datadog_secret" {
  secret_id = var.datadog_api_secret_arn
}

#Account level DataDog integration
module "datadog_integration" {
  # source                               = "github.com/StratusGrid/terraform-aws-datadog-integration-streaming"
  source            = "StratusGrid/datadog-integration-streaming/aws"
  version           = "1.0.1"
  name              = "${var.name_prefix}-integration-${data.aws_caller_identity.current.account_id}${local.name_suffix}"
  input_tags        = local.common_tags
  datadog_api_key   = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_app_key   = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_app_key"]
  datadog_api_url   = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_url"]
  datadog_host_tags = local.datadog_host_tags
  providers = {
    aws = aws.us-east-1
  }
}

#Per region level DataDog integration metrics streams with firehose
module "datadog_integration_us_east_1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-us-east-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.us-east-1
  }
}

module "datadog_integration_us_west_2" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-us-west-2${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.us-west-2
  }
}

module "datadog_integration_ca_central_1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-ca-central-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.ca-central-1
  }
}

module "datadog_integration_sa-east-1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-sa-east-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.sa-east-1
  }
}

module "datadog_integration_eu_west_2" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-eu-west-2${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.eu-west-2
  }
}

module "datadog_integration_eu_central_1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-eu-central-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.eu-central-1
  }
}

module "datadog_integration_ap_southeast_1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-ap-southeast-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.ap-southeast-1
  }
}

module "datadog_integration_ap_southeast_2" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-ap-southeast-2${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.ap-southeast-2
  }
}

module "datadog_integration_ap_northeast_1" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-ap-northeast-1${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.ap-northeast-1
  }
}

module "datadog_integration_ap_northeast_2" {
  # source                               = "github.com/StratusGrid/terraform-aws-firehose-datadog-metrics-streaming"
  source                               = "StratusGrid/firehose-datadog-metrics-streaming/aws"
  version                              = "1.0.1"
  name                                 = "${var.name_prefix}-metrics-${data.aws_caller_identity.current.account_id}-ap-northeast-2${local.name_suffix}"
  input_tags                           = local.common_tags
  datadog_api_key                      = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_api_key"]
  datadog_firehose_delivery_stream_url = jsondecode(data.aws_secretsmanager_secret_version.datadog_secret.secret_string)["datadog_firehose_delivery_stream_url"]
  providers = {
    aws = aws.ap-northeast-2
  }
}
```
---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 3.31 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.datadog_aws_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.datadog_aws_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.datadog_aws_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.datadog_aws_integration_security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [datadog_integration_aws.datadog_aws_integration](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_account_specific_namespace_rules"></a> [datadog\_account\_specific\_namespace\_rules](#input\_datadog\_account\_specific\_namespace\_rules) | Map defining the enabled DataDog AWS service integrations, defaults to disabling many for firehose metric streaming. | `map(string)` | <pre>{<br>  "api_gateway": false,<br>  "application_elb": false,<br>  "apprunner": false,<br>  "appstream": false,<br>  "appsync": false,<br>  "athena": false,<br>  "auto_scaling": false,<br>  "backup": false,<br>  "certificatemanager": false,<br>  "cloudfront": false,<br>  "cloudhsm": false,<br>  "cloudsearch": false,<br>  "cloudwatch_events": false,<br>  "cloudwatch_logs": false,<br>  "codebuild": false,<br>  "cognito": false,<br>  "connect": false,<br>  "directconnect": false,<br>  "dms": false,<br>  "documentdb": false,<br>  "dynamodb": false,<br>  "dynamodbaccelerator": false,<br>  "ebs": false,<br>  "ec2": false,<br>  "ec2api": false,<br>  "ec2spot": false,<br>  "ecr": false,<br>  "ecs": false,<br>  "efs": false,<br>  "elasticache": false,<br>  "elasticbeanstalk": false,<br>  "elasticinference": false,<br>  "elastictranscoder": false,<br>  "elb": false,<br>  "es": false,<br>  "firehose": false,<br>  "fsx": false,<br>  "gamelift": false,<br>  "glue": false,<br>  "inspector": false,<br>  "iot": false,<br>  "keyspaces": false,<br>  "kinesis": false,<br>  "kinesis_analytics": false,<br>  "kms": false,<br>  "lambda": false,<br>  "lex": false,<br>  "mediaconnect": false,<br>  "mediaconvert": false,<br>  "medialive": false,<br>  "mediapackage": false,<br>  "mediastore": false,<br>  "mediatailor": false,<br>  "ml": false,<br>  "mq": false,<br>  "msk": false,<br>  "mwaa": false,<br>  "nat_gateway": false,<br>  "neptune": false,<br>  "network_elb": false,<br>  "networkfirewall": false,<br>  "opsworks": false,<br>  "polly": false,<br>  "privatelinkendpoints": false,<br>  "privatelinkservices": false,<br>  "rds": false,<br>  "rdsproxy": false,<br>  "redshift": false,<br>  "rekognition": false,<br>  "route53": false,<br>  "route53resolver": false,<br>  "s3": false,<br>  "s3storagelens": false,<br>  "sagemaker": false,<br>  "sagemakerendpoints": false,<br>  "sagemakerlabelingjobs": false,<br>  "sagemakermodelbuildingpipeline": false,<br>  "sagemakerprocessingjobs": false,<br>  "sagemakertrainingjobs": false,<br>  "sagemakertransformjobs": false,<br>  "sagemakerworkteam": false,<br>  "service_quotas": false,<br>  "ses": false,<br>  "shield": false,<br>  "sns": false,<br>  "sqs": false,<br>  "step_functions": false,<br>  "storage_gateway": false,<br>  "swf": false,<br>  "textract": false,<br>  "transitgateway": false,<br>  "translate": false,<br>  "trusted_advisor": false,<br>  "vpn": false,<br>  "waf": false,<br>  "wafv2": false,<br>  "workspaces": false,<br>  "xray": false<br>}</pre> | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | Datadog API Key | `string` | n/a | yes |
| <a name="input_datadog_api_url"></a> [datadog\_api\_url](#input\_datadog\_api\_url) | Datadog API URL | `string` | n/a | yes |
| <a name="input_datadog_app_key"></a> [datadog\_app\_key](#input\_datadog\_app\_key) | Datadog Application Key | `string` | n/a | yes |
| <a name="input_datadog_host_tags"></a> [datadog\_host\_tags](#input\_datadog\_host\_tags) | List of strings to set as default key value pair tags on all data ingested from this integration. For example, ["environment:${var.aws\_account\_name}"] | `list(string)` | `null` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "StratusGrid",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | name to prepend to all resource names within module. NOTE: For this DataDog integration, it is recommended to use a format that includes the AWS Account number since it is account specific. | `string` | n/a | yes |

## Outputs

No outputs.

---

Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->