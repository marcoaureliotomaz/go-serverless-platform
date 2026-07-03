output "environment_summary" {
  description = "Summary of the dev environment foundation."
  value = {
    project         = var.project
    service         = var.service
    environment     = var.environment
    aws_region      = var.aws_region
    resource_prefix = var.resource_prefix
    lambda_names    = local.lambda_names
    api_routes      = local.api_routes
  }
}

output "planned_dynamodb_table_name" {
  description = "Planned DynamoDB table name for the POC."
  value       = module.dynamodb.planned_table_name
}

output "planned_lambda_names" {
  description = "Planned Lambda functions for the POC."
  value       = module.lambda.planned_lambda_names
}

output "planned_http_routes" {
  description = "Planned HTTP routes for the API Gateway."
  value       = module.api_gateway.planned_routes
}
