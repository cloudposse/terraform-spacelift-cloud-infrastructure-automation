stack_config_path = "./stacks"

stack_config_path_template = "stacks/%s.yaml"

branch = "master"

repository = "spacelift-demo"

terraform_version = "1.0.2"

terraform_version_map = {
  "0.12"  = "0.12.30"
  "0.13"  = "0.13.7"
  "0.14"  = "0.14.11"
  "0.15"  = "0.15.4"
  "1.0.2" = "1.0.2"
}

external_execution = true
