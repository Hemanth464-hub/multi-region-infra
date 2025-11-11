resource "random_password" "db_root_password" {
  length  = 16
  special = true
}

resource "google_sql_database_instance" "primary" {
  name             = "${var.name_prefix}-sql-primary"
  database_version = var.database_version
  region           = var.region_primary

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }

  deletion_protection = true
  root_password       = random_password.db_root_password.result
}

resource "google_sql_database_instance" "replica" {
  count  = var.create_replica ? 1 : 0
  name   = "${var.name_prefix}-sql-replica"
  region = var.region_secondary

  replica_configuration {
    master_instance_name = google_sql_database_instance.primary.name
  }

  depends_on = [google_sql_database_instance.primary]
}
