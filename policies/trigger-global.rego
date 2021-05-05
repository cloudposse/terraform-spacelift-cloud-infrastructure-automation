package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  entity := input.run.changes[_].entity

  input.run.state == "FINISHED"
  contains(entity.address, concat("", ["stacks[\"", stack.name, "\"].spacelift_mounted_file."]))
}
