# output "environments" {
#   value = [
#     for k, v in module.example : v
#   ]
# }

output "yaml" {
  value = module.example.yaml
}