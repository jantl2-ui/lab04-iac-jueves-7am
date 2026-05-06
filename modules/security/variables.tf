variable "environment" {
  description = "El entorno de despliegue (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se crearán los Security Groups"
  type        = string
}