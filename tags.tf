locals {
  tags = merge(var.input_tags, {
    "ModuleSourceRepo" = "github.com/StratusGrid/terraform-aws-datadog-integration-streaming"
  })
}