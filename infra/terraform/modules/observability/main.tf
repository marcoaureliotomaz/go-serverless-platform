locals {
  planned_log_groups = [
    for lambda_name in var.lambda_names : "/aws/lambda/${var.resource_prefix}-${lambda_name}"
  ]
}
