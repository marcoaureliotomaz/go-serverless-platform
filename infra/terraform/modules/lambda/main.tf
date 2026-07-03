locals {
  planned_function_names = [
    for lambda_name in var.lambda_names : "${var.resource_prefix}-${lambda_name}"
  ]
}
