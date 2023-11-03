variable "aws_region" {
  description = "AWS region to launch servers."
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^eu-.*|^us-.*|^ap-.*", var.aws_region))
    error_message = "Error: Incorrect AWS Region."
  }
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "wa_demo"

  validation {
    condition     = var.aws_profile != null && var.aws_profile != ""
    error_message = "Error: AWS Profile is absent."
  }
}

variable "project" {
  description = "Project name"
  type        = string
}


variable "environment" {
  description = "Role of the setup: non-prod or prod"
  type        = string
  default     = "dev-0"
}

variable "sg_tag" {
  description = "Security Group tag"
  type        = string
  default     = "Demo"
}