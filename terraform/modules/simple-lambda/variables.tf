variable "function_name" {
  description = <<EOF
"The name of your lambda function. this will include the environment name as a suffix. e.g. my-cool-function-dev
This must match the name of the lambda src directory under `lambdas`"
EOF
  type    = string
}

variable "src_build_dir" {
  description = "The output, build, or complied files directory of the lambda source code"
  default = null
  type = string
}

variable "artifact_bucket" {
  default = "capsule-lambdas"
}

variable "handler" {
  description = "The method in the function that is called and processes events. for example see https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html"
  type = string
}

variable "runtime" {
  default = "nodejs12.x"
}

variable "memory_size" {
  default = 512
}

variable "timeout" {
  default = 15
}

variable "log_retention" {
  default = 7
}