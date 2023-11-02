stack_config_path_template = "stacks/%s.yaml"

branch = "main"

repository = "spacelift-demo"

terraform_version = "1.4.6"

context_filters = {
  stages = ["dev"]
}

excluded_context_filters = {
  tenants = ["tenant3"]
  tags = {
    example = "excluded"
  }
}
