region               = "us-east-1"
bucket               = "example-dev-terraform-state"
key                  = "terraform.tfstate"
dynamodb_table       = "example-dev-terraform-state-lock"
encrypt              = "true"
workspace_key_prefix = "terraform-lambda"