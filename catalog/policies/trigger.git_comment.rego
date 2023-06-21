package spacelift

# This policy runs whenever a comment is added to a pull request. It looks for the comment body to contain either:
# /spacelift preview input.stack.id
# /spacelift deploy input.stack.id
#
# If the comment matches those patterns it will queue a tracked run (deploy) or a proposed run (preview). In the case of
# a proposed run, it will also cancel all of the other pending runs for the same branch.
#
# This is being used on conjunction with the GitHub actions `atmos-trigger-spacelift-feature-branch.yaml` and
# `atmos-trigger-spacelift-main-branch.yaml` in .github/workflows to automatically trigger a preview or deploy run based
# on the `atmos describe affected` output.

track {
	commented
	contains(input.pull_request.comment, concat(" ", ["/spacelift", "deploy", input.stack.id]))
}

propose {
	commented
	contains(input.pull_request.comment, concat(" ", ["/spacelift", "preview", input.stack.id]))
}

# Ignore if the event is not a comment
ignore {
	not commented
}

# Ignore if the PR has a `spacelift-no-trigger` label
ignore {
	input.pull_request.labels[_] = "spacelift-no-trigger"
}

# Ignore if the PR is a draft and deesnt have a `spacelift-trigger` label
ignore {
	input.pull_request.draft
	not has_spacelift_trigger_label
}

has_spacelift_trigger_label {
	input.pull_request.labels[_] == "spacelift-trigger"
}

commented {
	input.pull_request.action == "commented"
}

cancel[run.id] {
	run := input.in_progress[_]
	run.type == "PROPOSED"
	run.state == "QUEUED"
	run.branch == input.pull_request.head.branch
}

# This is a random sample of 10% of the runs
sample {
  millis := round(input.request.timestamp_ns / 1e6)
  millis % 100 <= 10
}
