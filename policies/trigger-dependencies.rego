package spacelift

# You can read more about trigger policies here:
#
# https://docs.spacelift.io/concepts/policy/trigger-policy

trigger[stack.id] {
  stack := input.stacks[_]
  input.run.state == "FINISHED"
  stack.labels[_] == concat("", [
    "depends-on:", input.stack.id,
    "|state:", input.run.state],
  )
}
