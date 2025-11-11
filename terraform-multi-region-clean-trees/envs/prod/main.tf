provider "google" {
  project = var.project_id
  region  = var.region_primary
}

module "network" {
  source            = "../../modules/network"
  project_id        = var.project_id
  name_prefix       = var.name_prefix
  region_primary    = var.region_primary
  region_secondary  = var.region_secondary
  cidr_us           = var.cidr_us
  cidr_eu           = var.cidr_eu
}

module "cloudsql" {
  source           = "../../modules/cloudsql"
  project_id       = var.project_id
  name_prefix      = var.name_prefix
  region_primary   = var.region_primary
  region_secondary = var.region_secondary
  database_version = var.database_version
  db_tier          = var.db_tier
  create_replica   = var.create_replica
}

module "loadbalancer" {
  source = "../../modules/loadbalancer"
  project_id = var.project_id
  name_prefix = var.name_prefix
  domains = var.lb_domains
}
