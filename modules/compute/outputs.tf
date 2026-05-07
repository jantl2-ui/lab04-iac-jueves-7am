output "upload_lambda_invoke_arn" {
  description = "ARN de invocación de la Lambda de Upload (requerido por API Gateway)"
  value       = aws_lambda_function.upload.invoke_arn
}

output "upload_lambda_function_name" {
  description = "Nombre de la función Lambda de Upload"
  value       = aws_lambda_function.upload.function_name
}

output "crop_lambda_arn" {
  description = "ARN de la Lambda de Crop"
  value       = aws_lambda_function.crop.arn
}

output "crop_lambda_function_name" {
  description = "Nombre de la función Lambda de Crop"
  value       = aws_lambda_function.crop.function_name
}