space_name = "Test Space"

description = "A test space"

labels = ["test", "space"]

# Policies
inline_policy_name = "Test Inline Policy"

inline_policy_type = "PLAN"

inline_policy_body = <<EOF
  package spacelift

  # PLAN policy that stops and waits for confirmation after a plan fails
  warn["Previous run did not succeed, review this one manually"] {
    input.spacelift.previous_run.state == "FAILED"
  }
EOF

inline_policy_labels = ["test", "terraform", "spacelift", "inline"]

catalog_policy_name = "Test Catalog Policy"

catalog_policy_type = "GIT_PUSH"

catalog_policy_body_url = "https://raw.githubusercontent.com/cloudposse/terraform-spacelift-cloud-infrastructure-automation/%s/catalog/policies/git_push.default.rego"

catalog_policy_body_url_version = "master"

catalog_policy_labels = ["test", "terraform", "spacelift", "catalog"]

file_policy_name = "Test Filepath Policy"

file_policy_type = "TRIGGER"

file_policy_body_path = "../../catalog/policies/trigger.dependencies.rego"

file_policy_labels = ["test", "terraform", "spacelift", "file", "path", "policy"]
