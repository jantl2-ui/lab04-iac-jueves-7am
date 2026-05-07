output "api_endpoint" {
  description = "URL base de ejecución del API Gateway HTTP"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "api_id" {
  description = "ID del API Gateway HTTP"
  value       = aws_apigatewayv2_api.http_api.id
}

output "api_execution_arn" {
  description = "ARN de ejecución del API Gateway"
  value       = aws_apigatewayv2_api.http_api.execution_arn
}