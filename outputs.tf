output "stacks" {
  description = "Generated stacks"
  value       = module.stacks
  sensitive   = true
}

output "current_admin_stack" {
  description = "The information or configuration of the stack currently executing this Terraform code."
  value       = module.spacelift_stacks_from_atmos_config.current_admin_stack
}
