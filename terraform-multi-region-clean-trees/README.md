# Terraform Multi-Region Infrastructure (clean-trees-477813-n2)

This package contains Terraform modules to deploy a multi-region infrastructure on GCP:
- modules/network: VPC, subnets, Cloud Router, Cloud NAT, firewall rules.
- modules/cloudsql: Cloud SQL primary + optional cross-region replica.
- modules/loadbalancer: scaffold for global HTTPS Load Balancer with Cloud Run backends.
- envs/prod: example environment configuration (GCS backend).

## Quickstart

1. Update `envs/prod/terraform.tfvars` with your `project_id` and other variables.
2. Create a GCS bucket for Terraform state:
   ```bash
   gsutil mb -p clean-trees-477813-n2 -l US gs://tfstate-clean-trees
   gsutil versioning set on gs://tfstate-clean-trees
   ```
3. Initialize and apply:
   ```bash
   cd envs/prod
   terraform init
   terraform plan -var-file=terraform.tfvars
   terraform apply -var-file=terraform.tfvars
   ```

## Notes
- Review and adjust machine types (db_tier), CIDR ranges, and IAM permissions before applying.
- The loadbalancer module is a scaffold — add serverless NEG backends or instance group backends per your app.
- Use Secret Manager for DB credentials and avoid hardcoding passwords.
