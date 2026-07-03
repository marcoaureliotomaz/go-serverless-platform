variable "project" {
  description = "Project identifier used in AWS tags."
  type        = string
  default     = "go-serverless-platform"
}

variable "service" {
  description = "Service name for this POC."
  type        = string
  default     = "person-service"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for the environment."
  type        = string
  default     = "us-east-1"
}

variable "resource_prefix" {
  description = "Prefix used to name AWS resources."
  type        = string
  default     = "poc-person-dev"
}

variable "owner" {
  description = "Owner tag for AWS resources."
  type        = string
  default     = "platform-team"
}

variable "managed_by" {
  description = "Managed by tag for AWS resources."
  type        = string
  default     = "terraform"
}
