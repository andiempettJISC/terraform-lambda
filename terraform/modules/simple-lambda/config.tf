# provider "aws" {
#   region                      = "us-east-1"
#   // access_key                  = terraform.workspace == "local" ? "fake" : null
#   // secret_key                  = terraform.workspace == "local" ? "fake" : null
#   skip_credentials_validation = terraform.workspace == "local" ? true : false
#   skip_metadata_api_check     = terraform.workspace == "local" ? true : false
#   skip_requesting_account_id  = terraform.workspace == "local" ? true : false

#   s3_force_path_style = terraform.workspace == "local" ? true : false

#   endpoints {
#     lambda         = terraform.workspace == "local" ? "http://localhost:4566" : null
#     s3             = terraform.workspace == "local" ? "http://localhost:4566" : null
#     iam            = terraform.workspace == "local" ? "http://localhost:4566" : null
#     cloudwatch     = terraform.workspace == "local" ? "http://localhost:4566" : null
#     cloudwatchlogs = terraform.workspace == "local" ? "http://localhost:4566" : null
#     sqs = terraform.workspace == "local" ? "http://localhost:4566" : null
#     apigateway = terraform.workspace == "local" ? "http://localhost:4566" : null
#     sts = terraform.workspace == "local" ? "http://localhost:4566" : null
#     cloudwatchevents = terraform.workspace == "local" ? "http://localhost:4566" : null
#   }
# }