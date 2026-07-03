locals {
  lambda_names = [
    "create-person",
    "get-person",
    "list-people",
    "update-person",
    "delete-person",
  ]

  api_routes = [
    "POST /v1/people",
    "GET /v1/people/{id}",
    "GET /v1/people",
    "PUT /v1/people/{id}",
    "DELETE /v1/people/{id}",
  ]

  default_tags = {
    project     = var.project
    service     = var.service
    environment = var.environment
    owner       = var.owner
    managed-by  = var.managed_by
  }
}
