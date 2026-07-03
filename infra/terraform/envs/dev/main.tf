module "iam" {
  source = "../../modules/iam"

  resource_prefix = var.resource_prefix
  service         = var.service
  environment     = var.environment
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  resource_prefix                  = var.resource_prefix
  service                          = var.service
  environment                      = var.environment
  billing_mode                     = "PAY_PER_REQUEST"
  hash_key                         = "pk"
  range_key                        = "sk"
  table_name_suffix                = "table"
  point_in_time_recovery_enabled   = true
  deletion_protection_enabled      = false
  ttl_enabled                      = false
  ttl_attribute_name               = "ttl"

  gsi_definitions = [
    {
      name            = "gsi1_list_by_created_at"
      hash_key        = "gsi1pk"
      range_key       = "gsi1sk"
      projection_type = "ALL"
    },
    {
      name            = "gsi2_name_prefix"
      hash_key        = "gsi2pk"
      range_key       = "gsi2sk"
      projection_type = "ALL"
    },
    {
      name            = "gsi3_active_by_created_at"
      hash_key        = "gsi3pk"
      range_key       = "gsi3sk"
      projection_type = "ALL"
    }
  ]
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
