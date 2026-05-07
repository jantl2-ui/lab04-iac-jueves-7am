output "dlq_alarm_arn" {
  description = "ARN de la alarma de CloudWatch asociada a la DLQ"
  value       = aws_cloudwatch_metric_alarm.dlq_alarm.arn
}

output "sns_topic_arn" {
  description = "ARN del tema SNS para alertas"
  value       = aws_sns_topic.alerts.arn
}

output "apigw_log_group_arn" {
  description = "ARN del CloudWatch Log Group para access logs del API Gateway"
  value       = aws_cloudwatch_log_group.apigw_logs.arn
}

output "upload_log_group_name" {
  description = "Nombre del log group de la Lambda de Upload"
  value       = aws_cloudwatch_log_group.upload_lambda_logs.name
}

output "crop_log_group_name" {
  description = "Nombre del log group de la Lambda de Crop"
  value       = aws_cloudwatch_log_group.crop_lambda_logs.name
}
