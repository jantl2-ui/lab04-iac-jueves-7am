output "api_endpoint" {
  description = "URL base de ejecución del API Gateway HTTP"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}