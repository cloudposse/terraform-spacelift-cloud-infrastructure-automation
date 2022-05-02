package spacelift

sample { true }

warn[sprintf("Detected deleted resource: %s", [resource.address])] {
  some resource
  deleted_resources[resource]
  input.stack.autodeploy
}

warn[sprintf("Detected recreated resource: %s", [resource.address])] {
  some resource
  recreated_resources[resource]
  input.stack.autodeploy
}

deny[sprintf("Must not create AWS IAM users: %s", [resource.address])] {
  some resource
  created_resources[resource]

  resource.type == "aws_iam_user"
}
