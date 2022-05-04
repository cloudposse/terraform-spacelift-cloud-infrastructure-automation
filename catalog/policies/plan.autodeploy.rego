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

# This could be a separate policy below

contains(list, elem) {
  list[_] = elem
}

denied_resources := [
  "aws_iam_user",
]

deny[sprintf("Must not create: %s", [resource.address])] {
  some resource
  created_resources[resource]

  contains(denied_resources, resource.type)
}
