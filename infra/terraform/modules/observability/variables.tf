variable "resource_prefix" {
  description = "Prefix used to name AWS resources."
  type        = string
}

variable "service" {
  description = "Service name for this module context."
  type        = string
}

variable "environment" {
  description = "Environment name for this module context."
  type        = string
}

variable "lambda_names" {
  description = "Logical Lambda names planned for the POC."
  type        = list(string)
  default     = []
}
