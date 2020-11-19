package spacelift

trigger[stack.id] {
  stack := input.stacks[_]
  component := regex.find_n(`[a-zA-Z0-9]+\-[a-zA-Z0-9]+\-[a-zA-Z0-9]+`, input.run.changes[_].entity.address, -1)[_]

  input.run.state == "FINISHED"
  regex.match(
    `module\.spacelift\.module\.spacelift_environment\[\"[a-zA-Z0-9\-]+\"\]\.module\.components`,
    input.run.changes[_].entity.address
  )
  component == stack.name
}