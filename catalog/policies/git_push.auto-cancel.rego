# https://docs.spacelift.io/concepts/policy/git-push-policy
# GIT_PUSH policy that triggers proposed runs when component files or YAML config files are modified in pull requests

package spacelift

# Cancel previous queued proposed runs if a new commit is pushed
# Tracked runs will not be cancelled
# https://docs.spacelift.io/concepts/policy/git-push-policy#canceling-in-progress-runs
cancel[run.id] {
  run := input.in_progress[_]
  run.type == "PROPOSED"
  run.state == "QUEUED"
  run.branch == input.pull_request.head.branch
}

sample { true }
