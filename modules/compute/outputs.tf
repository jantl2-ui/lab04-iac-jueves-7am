output "upload_lambda_invoke_arn" {
  description = "ARN de invocación de la Lambda de Upload (requerido por API Gateway)"
  value       = aws_lambda_function.upload.invoke_arn
}

output "crop_lambda_arn" {
  description = "ARN de la Lambda de Crop"
  value       = aws_lambda_function.crop.arn
}