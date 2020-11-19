package spacelift

trigger[stack.id] {
  stack := input.stacks[_]

  input.run.state == "FINISHED"
  input.stack.id != stack.id
  contains(
    input.run.changes[_].entity.address,
    "module.spacelift.module.global_context.spacelift_environment_variable.default"
  )
}