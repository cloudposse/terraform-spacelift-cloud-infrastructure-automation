package spacelift

sample { true }

deny["Major version is downgrading"] {
    change_after = input.terraform.resource_changes[_].change.after
    change_before = input.terraform.resource_changes[_].change.before
    # 14 > 13 so deny will be true (deny downgrade)
    # 13 > 13 so deny will be false (allow nothing)
    # 13 > 14 so deny will be false (allow upgrade)
    to_number(split(change_before.engine_version, ".")[0]) > to_number(split(change_after.engine_version, ".")[0])
}

deny["Minor version is downgrading"] {
    change_after = input.terraform.resource_changes[_].change.after
    change_before = input.terraform.resource_changes[_].change.before
    # 13 == 13 so deny will be true
    # 13.8 > 13.8 so deny will be false (allow nothing)
    # 13.8 > 13.7 so deny will be true (deny downgrade)
    # 13.7 > 13.8 so deny will be false (allow upgrade)
    to_number(split(change_before.engine_version, ".")[0]) == to_number(split(change_after.engine_version, ".")[0])
    to_number(split(change_before.engine_version, ".")[1]) > to_number(split(change_after.engine_version, ".")[1])
}
