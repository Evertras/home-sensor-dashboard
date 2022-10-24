variable "name" {
  description = "The name of the lambda."
  type        = string
}

variable "code" {
  description = "The raw code of the lambda."
  type        = string
}

variable "api_gateway_execution_arn" {
  description = "The execution ARN for the API gateway that should call this lambda"
  type        = string
}

variable "prefix" {
  description = "The prefix to use for naming"
  type        = string
}

variable "environment_vars" {
  description = "Environment variables to apply to the lambda"
  type        = map(string)
  default     = {}
}

locals {
  prefix = "${var.prefix}-${var.name}"
}
