package spacelift

# PLAN policy that stops and waits for confirmation after a plan fails
warn["Previous run did not succeed, review this one manually"] {
  input.spacelift.previous_run.state == "FAILED"
}
