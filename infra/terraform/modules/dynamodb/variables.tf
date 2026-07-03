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

variable "billing_mode" {
  description = "Billing mode for the DynamoDB table."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Primary partition key attribute name."
  type        = string
  default     = "pk"
}

variable "range_key" {
  description = "Primary sort key attribute name."
  type        = string
  default     = "sk"
}

variable "table_name_suffix" {
  description = "Suffix used to compose the DynamoDB table name."
  type        = string
  default     = "table"
}

variable "point_in_time_recovery_enabled" {
  description = "Whether point-in-time recovery should be enabled."
  type        = bool
  default     = true
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection should be enabled."
  type        = bool
  default     = false
}

variable "ttl_enabled" {
  description = "Whether TTL should be enabled for the table."
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "TTL attribute name when TTL is enabled."
  type        = string
  default     = "ttl"
}

variable "gsi_definitions" {
  description = "Global secondary indexes planned for the POC."
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = optional(string)
    projection_type = string
  }))
  default = [
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
