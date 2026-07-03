locals {
  planned_table_name = "${var.resource_prefix}-${var.table_name_suffix}"

  table_attributes = [
    {
      name = var.hash_key
      type = "S"
    },
    {
      name = var.range_key
      type = "S"
    },
    {
      name = "gsi1pk"
      type = "S"
    },
    {
      name = "gsi1sk"
      type = "S"
    },
    {
      name = "gsi2pk"
      type = "S"
    },
    {
      name = "gsi2sk"
      type = "S"
    },
    {
      name = "gsi3pk"
      type = "S"
    },
    {
      name = "gsi3sk"
      type = "S"
    }
  ]
}

resource "aws_dynamodb_table" "this" {
  name                        = local.planned_table_name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  deletion_protection_enabled = var.deletion_protection_enabled

  dynamic "attribute" {
    for_each = local.table_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi_definitions

    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = try(global_secondary_index.value.range_key, null)
      projection_type = global_secondary_index.value.projection_type
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []

    content {
      attribute_name = var.ttl_attribute_name
      enabled        = var.ttl_enabled
    }
  }
}
