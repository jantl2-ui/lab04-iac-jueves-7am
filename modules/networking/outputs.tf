output "vpc_id" {
  description = "El ID de la VPC principal"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "Lista de IDs de las subredes privadas"
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  description = "Lista de IDs de las subredes públicas"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}