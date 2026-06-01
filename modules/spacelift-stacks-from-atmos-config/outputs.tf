output "stacks" {
  description = "Generated stacks"
  value       = module.spacelift_config.spacelift_stacks
}

output "spacelift_stacks" {
  description = "Generated stacks"
  value       = local.spacelift_stacks
}

output "all_spacelift_stacks" {
  description = "All atmos stacks after context filtering (before tag filtering)"
  value       = local.all_spacelift_stacks
}

output "spacelift_stacks_extra_args" {
  description = "Resolved stack names keyed by atmos stack key"
  value       = local.spacelift_stacks_extra_args
}

output "current_admin_stack" {
  description = "Configuration of the stack currently executing this Terraform code"
  value       = local.current_admin_stack
}

output "current_admin_stack_id" {
  description = "Spacelift ID of the current admin stack"
  value       = local.current_admin_stack_id
}

output "managed_space_id" {
  description = "Space ID managed by the current admin stack"
  value       = local.current_admin_stack.managed_space_id
}
