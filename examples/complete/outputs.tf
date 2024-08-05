output "space" {
  description = "Spacelift space"
  value       = module.space.space
}

output "inline_policy" {
  value       = module.inline_policy.policy
  description = "The inline policy that was created"
}

output "catalog_policy" {
  value       = module.catalog_policy.policy
  description = "The catalog policy that was created"
}

output "file_policy" {
  value       = module.file_policy.policy
  description = "The file policy that was created"
}
