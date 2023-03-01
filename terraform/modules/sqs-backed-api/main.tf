// data "aws_caller_identity" "current" {}
// data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "api" {
  name        = "my-sqs-api"
  description = "POST records to SQS queue"
}

resource "aws_api_gateway_request_validator" "api" {
  rest_api_id           = aws_api_gateway_rest_api.api.id
  name                  = "payload-validator"
  validate_request_body = true
}

resource "aws_api_gateway_model" "api" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "PayloadValidator"
  description  = "validate the json body content conforms to the below spec"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "required": [ "id", "docs"],
  "properties": {
    "id": { "type": "string" },
    "docs": {
      "minItems": 1,
      "type": "array",
      "items": {
        "type": "object"
      }
    }
  }
}
EOF
}


resource "aws_api_gateway_method" "api" {
  rest_api_id          = "${aws_api_gateway_rest_api.api.id}"
  resource_id          = "${aws_api_gateway_rest_api.api.root_resource_id}"
  api_key_required     = false
  http_method          = "POST"
  authorization        = "NONE"

  request_validator_id = aws_api_gateway_request_validator.api.id
  request_models = {
    "application/json" = aws_api_gateway_model.api.name
  }
}

resource "aws_api_gateway_integration" "api" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method             = "POST"
  type                    = "AWS"
  integration_http_method = "POST"
  passthrough_behavior    = "NEVER"
  credentials             = "${aws_iam_role.api.arn}"
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.queue.name}"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }
  request_templates = {
    "application/json" = <<EOF
Action=SendMessage&MessageBody={
  "method": "$context.httpMethod",
  "body-json" : $input.json('$'),
  "queryParams": {
    #foreach($param in $input.params().querystring.keySet())
    "$param": "$util.escapeJavaScript($input.params().querystring.get($param))" #if($foreach.hasNext),#end
  #end
  },
  "pathParams": {
    #foreach($param in $input.params().path.keySet())
    "$param": "$util.escapeJavaScript($input.params().path.get($param))" #if($foreach.hasNext),#end
    #end
  }
}"
EOF
  }
}

resource "aws_api_gateway_integration_response" "success" {
  rest_api_id       = "${aws_api_gateway_rest_api.api.id}"
  resource_id       = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method       = "${aws_api_gateway_method.api.http_method}"
  status_code       = "${aws_api_gateway_method_response.success.status_code}"
  selection_pattern = "^2[0-9][0-9]" # regex pattern for any 200 message that comes back from SQS

  # response_templates = {
  #   "application/json" = "{\"status\":200,\"message\": \"great success\"}"
  # }

  depends_on = [aws_api_gateway_integration.api]
}

resource "aws_api_gateway_method_response" "success" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_method = "${aws_api_gateway_method.api.http_method}"
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "main"

  depends_on = [aws_api_gateway_integration.api]
}

output "invoke_url" {
  value =terraform.workspace == "local" ? "http://localhost:4566/restapis/${aws_api_gateway_rest_api.api.id}/main/_user_request_/" : aws_api_gateway_deployment.api.invoke_url
}