###
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  name_prefix = "${var.project}-${local.type}"
  type        = var.environment == "production" ? "prod" : "non-prod"
  common_tags = {
    Terraform   = "true"
    Environment = var.environment
    Type        = local.type
    Demo        = "true"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

### AWS instance resource
resource "aws_instance" "wa_demo" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  associate_public_ip_address = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance"
    }
  )

  lifecycle {
    # Create new instance before destroy present
    create_before_destroy = true

    # Ignore changes to tags, e.g. because a management agent
    # updates these based on some ruleset managed elsewhere.
    ignore_changes = [
      tags
    ]

    # The AMI ID must refer to an AMI that contains an operating system
    # for the `x86_64` architecture.
    precondition {
      condition     = data.aws_ami.ubuntu.architecture == "x86_64"
      error_message = "The selected AMI must be for the x86_64 architecture."
    }

    # The EC2 instance must be allocated a public DNS hostname.
    postcondition {
      condition     = self.public_dns != ""
      error_message = "EC2 instance must be in a VPC that has public DNS hostnames enabled."
    }

    # The instance tag "Terraform" must be "true"
    postcondition {
      condition     = self.tags["Terraform"] == "true"
      error_message = "tags[\"Terraform\"] must be \"true\"."
    }
  }
}
