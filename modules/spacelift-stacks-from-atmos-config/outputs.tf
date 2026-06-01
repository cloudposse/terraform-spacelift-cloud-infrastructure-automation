output "stacks" {
  description = "Generated stacks"
  value       = module.spacelift_config.spacelift_stacks
}

output "spacelift_stacks" {
  description = "Generated stacks"
  value       = local.spacelift_stacks
}
