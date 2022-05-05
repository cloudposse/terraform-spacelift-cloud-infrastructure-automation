package spacelift

sample { true }

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
