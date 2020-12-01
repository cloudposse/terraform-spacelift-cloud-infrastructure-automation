package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  entity := input.run.changes[_].entity
  
  input.run.state == "FINISHED"
  contains(entity.address, concat("", ["components[\"", stack.contexts[_], "\"]"]))
}

trigger[stack.id] {
  stack := input.stacks[_]
  entity := input.run.changes[_].entity
  
  input.run.state == "FINISHED"
  not contains(entity.address, "components")
  contains(entity.address, concat("", ["spacelift_environment[\"", stack.contexts[_], "\"]"]))
}

trigger[stack.id] {
  stack := input.stacks[_]
  entity := input.run.changes[_].entity

  input.run.state == "FINISHED"
  input.stack.id != stack.id
  contains(entity.address, "module.spacelift.module.global_context.spacelift_environment_variable.default")
}