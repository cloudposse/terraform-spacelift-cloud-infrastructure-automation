output "stacks" {
  description = "Generated stacks"
  value       = try(concat(module.stacks, module.root_stacks), module.stacks)
}
