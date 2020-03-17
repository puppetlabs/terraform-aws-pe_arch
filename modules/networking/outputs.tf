# output "network_link" {
#   value = google_compute_network.pe.self_link
# }

# output "subnetwork_link" {
#   value = google_compute_subnetwork.pe_west.self_link
# }

output "vpc_id" {
  value = aws_vpc.pe.id
}

output "subnet_id" {
  value = aws_subnet.pe_subnet.id
}

output "security_group_ids" {
  value = aws_security_group.pe_sg[*].id
}
