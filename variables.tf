variable "name" {
  description = "name to prepend to all resource names within module. NOTE: For this DataDog integration, it is recommended to use a format that includes the AWS Account number and region since it is account and region specific."
  type        = string
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "StratusGrid"
    Provisioner = "Terraform"
  }
}

#DataDog Variables
variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog Application Key"
  sensitive   = true
}

variable "datadog_api_url" {
  type        = string
  description = "Datadog API URL"
}

variable "datadog_firehose_delivery_stream_url" {
  type        = string
  description = "Datadog URL for the Firehose Delivery stream to send metrics. Marked sensitive because the some endpoints requires a key in the url."
  sensitive   = true
}

variable "datadog_host_tags" {
  type        = list(string)
  description = "List of strings to set as default key value pair tags on all data ingested from this integration. For example, [\"environment:$${var.aws_account_name}\"]"
}

variable "datadog_account_specific_namespace_rules" {
  type = map(string)
  description = "Map defining the enabled DataDog AWS service integrations"
  default = {
    "api_gateway"                    = false
    "application_elb"                = false
    "apprunner"                      = false
    "appstream"                      = false
    "appsync"                        = false
    "athena"                         = false
    "auto_scaling"                   = false
    "backup"                         = false
    "certificatemanager"             = false
    "cloudfront"                     = false
    "cloudhsm"                       = false
    "cloudsearch"                    = false
    "cloudwatch_events"              = false
    "cloudwatch_logs"                = false
    "codebuild"                      = false
    "cognito"                        = false
    "connect"                        = false
    "directconnect"                  = false
    "dms"                            = false
    "documentdb"                     = false
    "dynamodb"                       = false
    "dynamodbaccelerator"            = false
    "ebs"                            = false
    "ec2"                            = false
    "ec2api"                         = false
    "ec2spot"                        = false
    "ecr"                            = false
    "ecs"                            = false
    "efs"                            = false
    "elasticache"                    = false
    "elasticbeanstalk"               = false
    "elasticinference"               = false
    "elastictranscoder"              = false
    "elb"                            = false
    "es"                             = false
    "firehose"                       = false
    "fsx"                            = false
    "gamelift"                       = false
    "glue"                           = false
    "inspector"                      = false
    "iot"                            = false
    "keyspaces"                      = false
    "kinesis"                        = false
    "kinesis_analytics"              = false
    "kms"                            = false
    "lambda"                         = false
    "lex"                            = false
    "mediaconnect"                   = false
    "mediaconvert"                   = false
    "medialive"                      = false
    "mediapackage"                   = false
    "mediastore"                     = false
    "mediatailor"                    = false
    "ml"                             = false
    "mq"                             = false
    "msk"                            = false
    "mwaa"                           = false
    "nat_gateway"                    = false
    "neptune"                        = false
    "network_elb"                    = false
    "networkfirewall"                = false
    "opsworks"                       = false
    "polly"                          = false
    "privatelinkendpoints"           = false
    "privatelinkservices"            = false
    "rds"                            = false
    "rdsproxy"                       = false
    "redshift"                       = false
    "rekognition"                    = false
    "route53"                        = false
    "route53resolver"                = false
    "s3"                             = false
    "s3storagelens"                  = false
    "sagemaker"                      = false
    "sagemakerendpoints"             = false
    "sagemakerlabelingjobs"          = false
    "sagemakermodelbuildingpipeline" = false
    "sagemakerprocessingjobs"        = false
    "sagemakertrainingjobs"          = false
    "sagemakertransformjobs"         = false
    "sagemakerworkteam"              = false
    "service_quotas"                 = false
    "ses"                            = false
    "shield"                         = false
    "sns"                            = false
    "sqs"                            = false
    "step_functions"                 = false
    "storage_gateway"                = false
    "swf"                            = false
    "textract"                       = false
    "transitgateway"                 = false
    "translate"                      = false
    "trusted_advisor"                = false
    "vpn"                            = false
    "waf"                            = false
    "wafv2"                          = false
    "workspaces"                     = false
    "xray"                           = false
  }
}