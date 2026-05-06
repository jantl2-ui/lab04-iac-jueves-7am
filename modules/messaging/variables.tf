variable "environment" {
  description = "El entorno de despliegue"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID del bucket S3 que enviará las notificaciones a la cola"
  type        = string
}