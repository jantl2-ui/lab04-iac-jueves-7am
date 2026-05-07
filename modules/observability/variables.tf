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

variable "upload_lambda_function_name" {
  description = "Nombre de la función Lambda de Upload para métricas de errores"
  type        = string
}

variable "crop_lambda_function_name" {
  description = "Nombre de la función Lambda de Crop para métricas de errores"
  type        = string
}

variable "retention_in_days" {
  description = "Días de retención para los logs de CloudWatch según el entorno"
  type        = number
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.retention_in_days)
    error_message = "retention_in_days debe ser un valor válido de CloudWatch Logs."
  }
}
