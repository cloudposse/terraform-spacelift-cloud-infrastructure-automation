stack_config_path_template = "stacks/%s.yaml"

branch = "main"

repository = "spacelift-demo"

terraform_version = "1.0.7"

terraform_version_map = {
  "0.12"  = "0.12.30"
  "0.13"  = "0.13.7"
  "0.14"  = "0.14.11"
  "0.15"  = "0.15.4"
  "1.0.7" = "1.0.7"
}

external_execution = true
