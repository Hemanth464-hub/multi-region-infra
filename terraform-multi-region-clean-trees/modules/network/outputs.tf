output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "subnet_primary_self_link" {
  value = google_compute_subnetwork.subnet_primary.self_link
}

output "subnet_secondary_self_link" {
  value = google_compute_subnetwork.subnet_secondary.self_link
}

output "nat_primary_name" {
  value = google_compute_router_nat.nat_primary.name
}

output "nat_secondary_name" {
  value = google_compute_router_nat.nat_secondary.name
}
