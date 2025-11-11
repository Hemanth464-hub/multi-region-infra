variable "project_id" {
  type = string
}

variable "name_prefix" {
  type    = string
  default = "shopsphere"
}

variable "region_primary" {
  type    = string
  default = "us-central1"
}

variable "region_secondary" {
  type    = string
  default = "europe-west1"
}

variable "cidr_us" {
  type    = string
  default = "10.10.0.0/20"
}

variable "cidr_eu" {
  type    = string
  default = "10.20.0.0/20"
}

variable "database_version" {
  type    = string
  default = "POSTGRES_14"
}

variable "db_tier" {
  type    = string
  default = "db-custom-2-7680"
}

variable "create_replica" {
  type    = bool
  default = true
}

variable "lb_domains" {
  type = list(string)
  default = []
}
