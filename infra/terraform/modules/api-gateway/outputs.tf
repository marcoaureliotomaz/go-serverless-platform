output "planned_api_name" {
  description = "Planned API Gateway name."
  value       = local.planned_api_name
}

output "planned_routes" {
  description = "Planned API Gateway routes."
  value       = var.routes
}
