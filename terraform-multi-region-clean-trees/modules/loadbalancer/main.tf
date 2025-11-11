# Load Balancer module (Serverless NEGs for Cloud Run)
# Note: This module creates placeholders for the global HTTPS load balancer.
# You must supply actual serverless NEG backend endpoints (Cloud Run services) via variables.

resource "google_compute_global_address" "lb_ip" {
  name = "${var.name_prefix}-lb-ip"
}

resource "google_compute_managed_ssl_certificate" "managed_cert" {
  name = "${var.name_prefix}-managed-cert"
  project = var.project_id
  managed {
    domains = var.domains
  }
}

# URL map, target proxy, and forwarding rule
# Backend services are created from serverless NEG backends passed in as inputs.
# This is a minimal scaffold — adjust backend service timeouts, security policies, and CDN as needed.
