variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "El entorno debe ser 'dev', 'qa' o 'prod'."
  }
}

variable "project_name" {
  description = "Nombre base del proyecto. Se usa como prefijo en todos los recursos."
  type        = string
  default     = "image-processor"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,20}$", var.project_name))
    error_message = "project_name debe ser lowercase, empezar con letra, y tener entre 3 y 21 caracteres."
  }
}

variable "lambda_memory_crop" {
  description = "Memoria en MB asignada a la Lambda de procesamiento de imágenes"
  type        = number
  default     = 1024

  validation {
    condition     = var.lambda_memory_crop >= 128 && var.lambda_memory_crop <= 10240
    error_message = "lambda_memory_crop debe estar entre 128 y 10240 MB."
  }
}

variable "log_retention_days" {
  description = "Días de retención para los logs de CloudWatch"
  type        = number
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "log_retention_days debe ser un valor válido de CloudWatch Logs."
  }
}

variable "cors_allowed_origins" {
  description = "Lista de orígenes permitidos para CORS en API Gateway (restringir en producción)"
  type        = list(string)
  default     = ["*"]
}