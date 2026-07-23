package spacelift

test_track_comment_matches_stack_id {
	track with input as {
		"stack": {
			"id": "tenant-ue2-app",
			"name": "tenant-ue2-app",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-app deploy",
			"draft": false,
			"labels": [],
		},
	}
}

test_track_comment_matches_stack_name_when_id_is_slugified {
	# Spacelift slugifies IDs (dots -> dashes); the comment carries the name.
	track with input as {
		"stack": {
			"id": "tenant-ue2-app-1-0",
			"name": "tenant-ue2-app-1.0",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-app-1.0 deploy",
			"draft": false,
			"labels": [],
		},
	}
}

test_propose_comment_matches_stack_name_when_id_is_slugified {
	propose with input as {
		"stack": {
			"id": "tenant-ue2-app-1-0",
			"name": "tenant-ue2-app-1.0",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-app-1.0 preview",
			"draft": false,
			"labels": [],
		},
	}
}

test_no_track_when_comment_names_a_different_stack {
	not track with input as {
		"stack": {
			"id": "tenant-ue2-app-1-0",
			"name": "tenant-ue2-app-1.0",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-other deploy",
			"draft": false,
			"labels": [],
		},
	}
}

test_no_track_when_stack_name_is_a_prefix_of_commented_stack {
	# "tenant-ue2-app-1 deploy" must not be found inside "tenant-ue2-app-1.0 deploy"
	not track with input as {
		"stack": {
			"id": "tenant-ue2-app-1",
			"name": "tenant-ue2-app-1",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-app-1.0 deploy",
			"draft": false,
			"labels": [],
		},
	}
}

test_ignore_when_not_commented {
	ignore with input as {
		"stack": {
			"id": "tenant-ue2-app",
			"name": "tenant-ue2-app",
		},
		"pull_request": {
			"action": "opened",
			"comment": "",
			"draft": false,
			"labels": [],
		},
	}
}

test_ignore_draft_without_trigger_label {
	ignore with input as {
		"stack": {
			"id": "tenant-ue2-app-1-0",
			"name": "tenant-ue2-app-1.0",
		},
		"pull_request": {
			"action": "commented",
			"comment": "/spacelift tenant-ue2-app-1.0 deploy",
			"draft": true,
			"labels": [],
		},
	}
}
