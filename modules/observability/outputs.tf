output "dlq_alarm_arn" {
  description = "ARN de la alarma de CloudWatch asociada a la DLQ"
  value       = aws_cloudwatch_metric_alarm.dlq_alarm.arn
}

