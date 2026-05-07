output "main_queue_arn" {
  description = "ARN de la cola SQS principal"
  value       = aws_sqs_queue.main_queue.arn
}

output "main_queue_url" {
  description = "URL de la cola SQS principal"
  value       = aws_sqs_queue.main_queue.url
}

output "dlq_name" {
  description = "Nombre de la Dead-Letter Queue (para las alarmas de CloudWatch)"
  value       = aws_sqs_queue.dlq.name
}

output "dlq_arn" {
  description = "ARN de la Dead-Letter Queue"
  value       = aws_sqs_queue.dlq.arn
}