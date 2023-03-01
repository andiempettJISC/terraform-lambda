data "archive_file" "simple_lambda_artifact" {
  type = "zip"

  source_dir  = var.src_build_dir != null ? "${path.root}/../lambdas/${var.function_name}/${var.src_build_dir}"  : "${path.root}/../lambdas/${var.function_name}"
  output_path = "${path.root}/builds/${var.function_name}-${terraform.workspace}.zip"
}

resource "aws_s3_bucket_object" "simple_lambda_artifact_upload" {
  bucket = "${var.artifact_bucket}-${terraform.workspace}"

  key    = "${basename(abspath("${path.root}/../"))}/${terraform.workspace}/${var.function_name}/${filemd5(data.archive_file.simple_lambda_artifact.output_path)}.zip"
  source = data.archive_file.simple_lambda_artifact.output_path

  etag = filemd5(data.archive_file.simple_lambda_artifact.output_path)
}

resource "aws_lambda_function" "simple_lambda_function" {

  function_name = "${var.function_name}-${terraform.workspace}"
  s3_bucket     = "${var.artifact_bucket}-${terraform.workspace}"
  s3_key        = aws_s3_bucket_object.simple_lambda_artifact_upload.key
  handler       = var.handler
  role          = aws_iam_role.simple_lambda_role.arn
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_code_hash = data.archive_file.simple_lambda_artifact.output_base64sha256
}