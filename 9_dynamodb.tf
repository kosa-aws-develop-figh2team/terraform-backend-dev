resource "aws_dynamodb_table" "processing_metadata" {
  name           = "ProcessingMetadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "service_id"

  attribute {
    name = "service_id"
    type = "S"
  }

  # (선택) TTL 활성화하려면 아래 주석 해제
  # ttl {
  #   attribute_name = "timestamp"
  #   enabled        = true
  # }

  tags = {
    Name        = var.dynamodb_table_name
    Environment = var.environment
  }
}