variable "environment" {
  description = "El entorno de despliegue"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "random_suffix" {
  description = "Sufijo aleatorio para garantizar la unicidad del nombre del bucket S3"
  type        = string
}