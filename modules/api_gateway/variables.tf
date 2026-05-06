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