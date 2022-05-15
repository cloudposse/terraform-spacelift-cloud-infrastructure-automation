package spacelift

test_propose_project_root_affected {
  propose with input as {
    "stack": {
      "project_root": "components/terraform/ecr",
      "labels": [],
    },
    "pull_request": {
      "action": "opened",
      "draft": false,
      "labels": [],
      "diff": ["components/terraform/ecr/main.tf"],
    },
  }
}

test_propose_stack_config_affected_imports_label {
  propose with input as {
    "stack": {
      "project_root": "components/terraform/ecr",
      "labels": ["import:stacks/catalog/ecr.yaml"],
    },
    "pull_request": {
      "action": "opened",
      "draft": false,
      "labels": [],
      "diff": ["stacks/catalog/ecr.yaml"],
    },
  }
}

test_propose_stack_config_affected_deps_label {
  propose with input as {
    "stack": {
      "project_root": "components/terraform/ecr",
      "labels": [
        "deps:stacks/ue2-globals.yaml",
        "deps:stacks/ue2-artifacts.yaml",
        "deps:stacks/catalog/ecr.yaml",
      ],
    },
    "pull_request": {
      "action": "opened",
      "draft": false,
      "labels": [],
      "diff": ["stacks/catalog/ecr.yaml"],
    },
  }
}

test_propose_stack_config_affected_stack_name_root_stack {
  propose with input as {
    "stack": {
      "name": "ue2-artifacts-ecr",
      "project_root": "components/terraform/ecr",
      "labels": [],
    },
    "pull_request": {
      "action": "opened",
      "draft": false,
      "labels": [],
      "diff": ["stacks/ue2-artifacts.yaml"],
    },
  }
}

test_propose_stack_config_affected_stack_stack_label {
  propose with input as {
    "stack": {
      "name": "ue2-artifacts-ecr",
      "project_root": "components/terraform/ecr",
      "labels": ["stack:stacks/ue2-artifacts.yaml"],
    },
    "pull_request": {
      "action": "opened",
      "draft": false,
      "labels": [],
      "diff": ["stacks/ue2-artifacts.yaml"],
    },
  }
}

test_ignore_ready_to_review_with_spacelift_no_trigger_label {
  ignore with input as {"pull_request": {
    "draft": false,
    "labels": ["spacelift-no-trigger"],
  }}
}

test_not_ignore_ready_to_review_without_any_labels {
  not ignore with input as {"pull_request": {
    "draft": false,
    "labels": [],
  }}
}

test_not_ignore_draft_with_spacelift_trigger_label {
  not ignore with input as {"pull_request": {
    "draft": true,
    "labels": ["spacelift-trigger"],
  }}
}

test_ignore_draft_without_any_labels {
  ignore with input as {"pull_request": {
    "draft": true,
    "labels": [],
  }}
}

test_cancel_runs {
  cancel.test with input as {
    "pull_request": {"head": {"branch": "main"}},
    "in_progress": [{
      "id": "test",
      "type": "PROPOSED",
      "state": "QUEUED",
      "branch": "main",
    }],
  }
}

test_not_cancel_runs {
  not cancel.test with input as {
    "pull_request": {"head": {"branch": "feature/example"}},
    "in_progress": [{
      "id": "test",
      "type": "PROPOSED",
      "state": "QUEUED",
      "branch": "main",
    }],
  }
}
