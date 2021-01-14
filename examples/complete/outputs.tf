output "environments" {
  value = [
    for k, v in module.example : v
  ]
}

output "yaml" {
  value = local.stack_config_files
}

# output "yaml_config" {
#   value = module.example.yaml
# }