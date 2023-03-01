resource "aws_sqs_queue" "queue" {
  name                      = "example-sqs-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

}

output "sqsurl" {
  value = aws_sqs_queue.queue.url
}

output "sqsarn" {
  value = aws_sqs_queue.queue.arn
}


resource "aws_lambda_permission" "allows_sqs_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = "example-function"
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.queue.arn
}

# Trigger lambda on message to SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = 1
  event_source_arn =  aws_sqs_queue.queue.arn
  enabled          = true
  function_name    =  var.function_arn
}

data "aws_iam_policy_document" "lambda_sqs_policy_doc" {
  statement {
    sid       = "AllowSQSAccess"
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.queue.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_sqs_policy" {
  name   = "example_lambda_sqs_policy"
  policy = data.aws_iam_policy_document.lambda_sqs_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = var.function_role
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}