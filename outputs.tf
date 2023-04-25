output "stacks" {
  description = "Generated stacks"
  value       = module.stacks
}

output "current_admin_stack" {
  description = "The information or configuration of the stack currently executing this Terraform code."
  value       = local.current_admin_stack
}
