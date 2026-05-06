variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
  default     = "image-processor"
}

variable "lambda_memory_crop" {
  description = "Memoria asignada a la Lambda de procesamiento"
  type        = number
}

variable "log_retention_days" {
  description = "Días de retención para los logs de CloudWatch"
  type        = number
}