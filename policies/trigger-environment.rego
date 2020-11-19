package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  environment := regex.find_n(`[a-zA-Z0-9]+\-[a-zA-Z0-9]+`, input.run.changes[_].entity.address, 1)[0]

  input.run.state == "FINISHED"
  regex.match(
    `module\.spacelift\.module\.spacelift_environment\[\"[a-zA-Z0-9\-]+\"\]\.module\.environment_context.spacelift_environment_variable`,
    input.run.changes[_].entity.address
  )
  contains(stack.contexts[_], environment)
}