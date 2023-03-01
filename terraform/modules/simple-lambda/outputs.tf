output "lambda_role" {
  value = aws_lambda_function.simple_lambda_function.role
}

output "lambda_arn" {
  value = aws_lambda_function.simple_lambda_function.arn
}

output "lambda_role_name" {
  value = aws_iam_role.simple_lambda_role.name
}