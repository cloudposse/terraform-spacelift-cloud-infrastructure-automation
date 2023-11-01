stack_config_path_template = "stacks/%s.yaml"

branch = "main"

repository = "spacelift-demo"

terraform_version = "1.4.6"

context_filters = {
  stages = ["dev"]
}

excluded_context_filters = {
  tags = {
    example = "excluded"
  }
}
