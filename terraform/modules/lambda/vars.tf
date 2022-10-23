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

locals {
  prefix = "evertras-home-dashboard-${var.name}"
}
