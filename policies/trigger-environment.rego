package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  input.run.type == "TRACKED"
  input.run.changes[_].entity.type == "spacelift_environment_variable"
  contains(input.run.changes[_].entity.address, stack.contexts[_])
}