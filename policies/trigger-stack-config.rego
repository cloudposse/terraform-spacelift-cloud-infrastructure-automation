package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  input.run.type == "TRACKED"
  input.run.changes[_].entity.type == "spacelift_environment_variable"

  contains(
    regex.find_n(`[a-zA-Z0-9]+\-[a-zA-Z0-9]+\-[a-zA-Z0-9]+`, input.run.changes[_].entity.address, -1)[_],
    stack.name
  )
}