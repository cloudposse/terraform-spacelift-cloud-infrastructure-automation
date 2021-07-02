package spacelift

test_warn_if_previous_run_failed {
  count(warn) == 1 with input as { "spacelift": { "previous_run": { "state": "FAILED" } } }
}

test_empty_warn_if_previous_run_failed {
  count(warn) == 0 with input.spacelift as { "previous_run": { "state": "SUCCEEDED" } }
}
