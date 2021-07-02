package spacelift

stack = { "id": "This is a test of the emergency broadcasting system." }

test_trigger_if_previous_tracked_run_failed {
  count(trigger) == 1 with input as { "run": { "state": "FAILED", "type": "TRACKED", "triggered_by": null } } with input.stack as stack
}

test_not_trigger_if_previous_tracked_run_succeeded {
  count(trigger) == 0 with input as { "run": { "state": "SUCCEEDED", "type": "TRACKED", "triggered_by": null } } with input.stack as stack
}

test_not_trigger_if_previous_untracked_run_succeeded {
  count(trigger) == 0 with input as { "run": { "state": "SUCCEEDED", "type": "UNTRACKED", "triggered_by": null } } with input.stack as stack
}

test_not_trigger_if_previous_untracked_run_failed {
  count(trigger) == 0 with input as { "run": { "state": "FAILED", "type": "UNTRACKED", "triggered_by": null } } with input.stack as stack
}

test_not_trigger_if_previous_tracked_run_failed_but_was_triggered_by {
  count(trigger) == 0 with input as { "run": { "state": "FAILED", "type": "TRACKED", "triggered_by": "@Gowiem" } } with input.stack as stack
}
