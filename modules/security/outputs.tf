output "upload_sg_id" {
  description = "ID del Security Group para la Lambda de Upload"
  value       = aws_security_group.upload_lambda.id
}

output "crop_sg_id" {
  description = "ID del Security Group para la Lambda de Crop"
  value       = aws_security_group.crop_lambda.id
}

output "vpce_sqs_sg_id" {
  description = "ID del Security Group para el VPC Endpoint de SQS"
  value       = aws_security_group.vpce_sqs.id
}

output "upload_role_arn" {
  description = "ARN del rol de IAM para la Lambda de Upload"
  value       = aws_iam_role.upload_lambda_role.arn
}

output "crop_role_arn" {
  description = "ARN del rol de IAM para la Lambda de Crop"
  value       = aws_iam_role.crop_lambda_role.arn
}