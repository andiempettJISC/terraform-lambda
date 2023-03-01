resource "aws_iam_role" "simple_lambda_role" {
  name = "${var.function_name}-${terraform.workspace}"

  assume_role_policy = <<-POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "simple_lambda_policy" {
  role       = aws_iam_role.simple_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}