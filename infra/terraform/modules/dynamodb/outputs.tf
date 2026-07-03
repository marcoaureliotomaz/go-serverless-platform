output "planned_table_name" {
  description = "Name of the DynamoDB table created for the POC."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table created for the POC."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "ID of the DynamoDB table created for the POC."
  value       = aws_dynamodb_table.this.id
}

output "gsi_names" {
  description = "Names of the global secondary indexes configured for the POC."
  value       = [for gsi in var.gsi_definitions : gsi.name]
}

output "primary_key_definition" {
  description = "Primary key definition of the DynamoDB table."
  value = {
    hash_key  = var.hash_key
    range_key = var.range_key
  }
}
