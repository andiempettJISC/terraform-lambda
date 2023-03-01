resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.function_name}-${terraform.workspace}"
  retention_in_days = var.log_retention
}