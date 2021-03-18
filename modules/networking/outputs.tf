# Output data that will be used by other submodules to build other parts of the
# stack to support defined architecture
output "vpc_id" {
  value       = aws_vpc.pe.id
  description = "AWS VPC id"

}

output "subnet_ids" {
  value       = aws_subnet.pe_subnet[*].id
  description = "AWS subnet ids"
}

output "security_group_ids" {
  value       = aws_security_group.pe_sg[*].id
  description = "AWS security group ids"
}