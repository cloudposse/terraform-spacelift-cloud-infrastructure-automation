package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  entity := input.run.changes[_].entity
  
  input.run.state == "FINISHED"
  contains(entity.address, concat("", ["components[\"", stack.contexts[_], "\"]"]))
}