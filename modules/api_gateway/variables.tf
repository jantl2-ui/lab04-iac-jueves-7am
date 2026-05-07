variable "environment" {
  description = "El entorno de despliegue"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "upload_lambda_invoke_arn" {
  description = "ARN de invocación de la Lambda que procesará las subidas"
  type        = string
}

variable "upload_lambda_function_name" {
  description = "Nombre de la función Lambda de Upload (para el permiso de invocación)"
  type        = string
}

variable "cors_allowed_origins" {
  description = "Lista de orígenes permitidos para CORS. Usar ['*'] solo en dev."
  type        = list(string)
  default     = ["*"]
}

variable "access_log_group_arn" {
  description = "ARN del CloudWatch Log Group para access logs del API Gateway"
  type        = string
}