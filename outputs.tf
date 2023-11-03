output "instance_name" {
  description = "Instance name"
  value       = aws_instance.wa_demo.tags
  precondition {
    condition     = aws_instance.wa_demo.tags["Name"] != null && aws_instance.wa_demo.tags["Name"] != ""
    error_message = "The instance must be named."
  }
}

output "instance_public_ip" {
  description = "value"
  value       = aws_instance.wa_demo.public_ip
}