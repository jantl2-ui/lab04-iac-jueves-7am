variable "environment" {
  description = "El entorno de despliegue"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "dlq_queue_name" {
  description = "Nombre de la DLQ para monitorear mensajes no procesados"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN del tema SNS para enviar notificaciones de alarma"
  type        = string
}

variable "retention_in_days" {
  description = "Días de retención para los logs de CloudWatch según el entorno"
  type        = number
}

