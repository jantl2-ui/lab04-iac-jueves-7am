output "main_queue_arn" {
  description = "ARN de la cola SQS principal"
  value       = aws_sqs_queue.main_queue.arn
}

output "dlq_name" {
  description = "Nombre de la Dead-Letter Queue (para las alarmas de CloudWatch)"
  value       = aws_sqs_queue.dlq.name
}