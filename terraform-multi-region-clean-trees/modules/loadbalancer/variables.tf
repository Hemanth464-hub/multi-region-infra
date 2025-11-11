variable "project_id" {
  type = string
}

variable "name_prefix" {
  type = string
  default = "shopsphere"
}

variable "domains" {
  type = list(string)
  default = []
}

variable "serverless_negs" {
  type = list(string)
  default = []
}
