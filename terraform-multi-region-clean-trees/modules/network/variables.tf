variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
  default     = "shopsphere"
}

variable "region_primary" {
  description = "Primary region for resources"
  type        = string
  default     = "us-central1"
}

variable "region_secondary" {
  description = "Secondary region"
  type        = string
  default     = "europe-west1"
}

variable "cidr_us" {
  description = "CIDR for us-central1 subnet"
  type        = string
  default     = "10.10.0.0/20"
}

variable "cidr_eu" {
  description = "CIDR for europe-west1 subnet"
  type        = string
  default     = "10.20.0.0/20"
}
