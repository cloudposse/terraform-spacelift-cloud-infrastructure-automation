output "config" {
    value = {
        id                = spacelift_stack.default[0].id
        name              = spacelift_stack.default[0].name
        autodeploy        = spacelift_stack.default[0].autodeploy
        terraform_version = spacelift_stack.default[0].terraform_version
        repository        = spacelift_stack.default[0].repository
        branch            = spacelift_stack.default[0].branch
    }
}
