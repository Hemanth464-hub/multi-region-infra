output "primary_instance_name" {
  value = google_sql_database_instance.primary.name
}

output "replica_instance_name" {
  value = length(google_sql_database_instance.replica) > 0 ? google_sql_database_instance.replica[0].name : ""
}
