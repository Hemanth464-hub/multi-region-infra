terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_primary
}

locals {
  network_name = "${var.name_prefix}-vpc"
}

resource "google_compute_network" "vpc" {
  name                    = local.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "Custom VPC for ${var.name_prefix}"
}

resource "google_compute_subnetwork" "subnet_primary" {
  name                     = "${var.name_prefix}-subnet-${replace(var.region_primary, "-", "") }"
  ip_cidr_range            = var.cidr_us
  region                   = var.region_primary
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_secondary" {
  name                     = "${var.name_prefix}-subnet-${replace(var.region_secondary, "-", "") }"
  ip_cidr_range            = var.cidr_eu
  region                   = var.region_secondary
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_router" "router_primary" {
  name    = "${var.name_prefix}-cr-${replace(var.region_primary, "-", "") }"
  network = google_compute_network.vpc.self_link
  region  = var.region_primary
  bgp {
    asn = 64514
  }
}

resource "google_compute_router" "router_secondary" {
  name    = "${var.name_prefix}-cr-${replace(var.region_secondary, "-", "") }"
  network = google_compute_network.vpc.self_link
  region  = var.region_secondary
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_primary" {
  name                               = "${var.name_prefix}-nat-${replace(var.region_primary, "-", "") }"
  router                             = google_compute_router.router_primary.name
  region                             = var.region_primary
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet_primary.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ALL"
  }
}

resource "google_compute_router_nat" "nat_secondary" {
  name                               = "${var.name_prefix}-nat-${replace(var.region_secondary, "-", "") }"
  router                             = google_compute_router.router_secondary.name
  region                             = var.region_secondary
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet_secondary.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ALL"
  }
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.name_prefix}-allow-internal"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.cidr_us, var.cidr_eu]
  direction     = "INGRESS"
  priority      = 1000
  description   = "Allow internal VPC traffic between subnets"
}

resource "google_compute_firewall" "allow_https_ingress" {
  name    = "${var.name_prefix}-allow-https"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
  direction     = "INGRESS"
  priority      = 1000
  description   = "Allow external HTTPS to VMs/IG backends tagged https-server"
}

resource "google_compute_firewall" "allow_egress_https" {
  name    = "${var.name_prefix}-allow-egress-https"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority           = 1000
  description        = "Allow outbound HTTPS for updates and API calls"
}
