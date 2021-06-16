package spacelift

# TRIGGER policy that allows automatically restarting the failed run

# You can read more about trigger policies here:
#
# https://docs.spacelift.io/concepts/policy/trigger-policy

trigger[stack.id] {
  stack := input.stack
  input.run.state == "FAILED"
  input.run.type == "TRACKED"
  is_null(input.run.triggered_by)
}

# Note that this policy will also prevent user-triggered runs from being retried.
# Which is usually what you want in the first place, because a triggering human is probably already babysitting the Stack anyway.
