module "example-lambda" {
  source = "./modules/simple-lambda"

  function_name = "example-function"
  handler       = "index.handler"

}

# module "example-api" {
#   source = "./modules/sqs-backed-api"

#   function_arn = module.example-lambda.lambda_arn
#   function_role = module.example-lambda.lambda_role_name

#   # prevents possible race condition with lambda resources existing and sqs event mapping
#   depends_on = [
#     module.example-lambda
#   ]
# }

# output "function_name" {
#   value = module.example-lambda.lambda_role
# }

# output "sqs_url" {
#   value = module.example-api.sqsurl
# }

# output "invoke_url" {
#   value = module.example-api.invoke_url
# }