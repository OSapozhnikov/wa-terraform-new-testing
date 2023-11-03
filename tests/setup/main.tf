terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_pet" "project_name" {
  length = 1
}

resource "random_shuffle" "environment" {
  input        = ["dev-1", "dev-0", "production"]
  result_count = 1
}

locals {
  type = random_shuffle.environment.id == "production" ? "prod" : "non-prod"
}

output "project_name" {
  value = random_pet.project_name.id
}

output "environment_name" {
  value = random_shuffle.environment.id
}

output "environment_type" {
  value = local.type
}