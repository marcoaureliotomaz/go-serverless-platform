module "iam" {
  source = "../../modules/iam"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
}

module "lambda" {
  source = "../../modules/lambda"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
  lambda_names    = local.lambda_names
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
  routes          = local.api_routes
}

module "observability" {
  source = "../../modules/observability"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
  lambda_names    = local.lambda_names
}
