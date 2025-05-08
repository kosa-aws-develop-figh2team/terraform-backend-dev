resource "aws_lambda_function" "preprocessing_service" {
  function_name = "preprocessing-service"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.preprocessing_service.repository_url}:latest" 
  timeout       = 300

  environment {
    variables = {
      STAGE = "prod"
    }
  }

  tags = {
    Name        = var.dynamodb_table_name
    Environment = var.environment
  }
}

# DynamoDB 스트림 → Lambda 트리거 연결 + 필터 조건 설정
resource "aws_lambda_event_source_mapping" "dynamodb_to_lambda" {
  event_source_arn = aws_dynamodb_table.processing_metadata.stream_arn
  function_name    = aws_lambda_function.preprocessing_service.arn
  starting_position = "LATEST"
  batch_size        = 1
  enabled           = true

  filter_criteria {
    filter {
      pattern = jsonencode({
        eventName = ["INSERT", "MODIFY"],
        dynamodb = {
          NewImage = {
            step = {
              S = ["init"]
            }
          }
        }
      })
    }
  }
}