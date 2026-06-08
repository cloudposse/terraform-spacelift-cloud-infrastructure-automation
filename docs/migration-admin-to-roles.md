# Migration Guide: Administrative Flag → Stack Role Attachments

Spacelift deprecated the `administrative = true` stack attribute. As of June 1 2026, the flag is
ineffective in the GraphQL API. This module version replaces it with `spacelift_role_attachment`
using the built-in `space-admin` role.

**Spacelift references:**
- [Changelog](https://feedback.spacelift.io/changelog/introducing-advanced-stack-roles-in-spacelift)
- [Stack role bindings docs](https://docs.spacelift.io/concepts/authorization/assigning-roles-stacks.html)

---

## What changed in this module

| Before | After |
|---|---|
| `administrative = var.administrative` on `spacelift_stack` | Removed — flag is no longer accepted |
| `data.spacelift_current_stack.administrative` at root level | Moved into `modules/spacelift-stacks-from-atmos-config/current_admin_stack.tf` |
| `modules/stack` (flat, single-file) | `modules/spacelift-stack` (upstream-aligned, multi-file) |
| `module "spacelift_config"` calling cloudposse registry | `module "spacelift_stacks_from_atmos_config"` calling local `./modules/spacelift-stacks-from-atmos-config` |
| `infrastructure_stack_name` variable | Renamed to `atmos_stack_name` (`infrastructure_stack_name` kept as deprecated alias) |
| Provider `>= 0.1.27` | Provider `>= 1.37.0` (required for `spacelift_role_attachment`) |

New resources created per admin stack:
- `data.spacelift_role.space_admin` — resolves built-in `space-admin` role by slug
- `spacelift_role_attachment.admin` — binds `space-admin` to the stack's managed space

---

## Removed variables

These root-level variables were removed. Update callers accordingly:

| Removed variable | Notes |
|---|---|
| _(none removed yet — planned for next release)_ | `administrative_*` variables are kept for backward compatibility in this release |

The following are **deprecated** and will be removed in a future release:
- `administrative_trigger_policy_enabled`
- `administrative_push_policy_enabled`
- `administrative_stack_drift_detection_enabled`
- `administrative_stack_drift_detection_reconcile`
- `administrative_stack_drift_detection_schedule`

---

## Terraform state migration

### Why state migration is needed

The submodule restructure renames resource addresses. Terraform will attempt to **destroy and recreate** resources unless you run `terraform state mv` first.

**Before applying**, run these commands inside the infrastructure container against each admin stack's state:

```bash
# module.stacks[*] → module.stacks[*] (source changed from modules/stack to modules/spacelift-stack)
# Resource names inside the module changed from .default to .this

# For each stack key (replace <KEY> with the atmos stack key, e.g. "gbl-corp-infrastructure"):
terraform state mv \
  'module.stacks["<KEY>"].spacelift_stack.default[0]' \
  'module.stacks["<KEY>"].spacelift_stack.this[0]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_run.default[0]' \
  'module.stacks["<KEY>"].spacelift_run.this[0]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_mounted_file.stack_config[0]' \
  'module.stacks["<KEY>"].spacelift_mounted_file.stack_config[0]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_stack_destructor.default[0]' \
  'module.stacks["<KEY>"].spacelift_stack_destructor.this[0]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_policy_attachment.default[0]' \
  'module.stacks["<KEY>"].spacelift_policy_attachment.this["<POLICY_ID>"]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_aws_role.default[0]' \
  'module.stacks["<KEY>"].spacelift_aws_role.this[0]'

terraform state mv \
  'module.stacks["<KEY>"].spacelift_drift_detection.default[0]' \
  'module.stacks["<KEY>"].spacelift_drift_detection.this[0]'
```

> **Note:** `spacelift_policy_attachment` changed from `count` to `for_each` — the new address uses the policy ID as the map key.

### Importing auto-migrated role attachments

Spacelift auto-migrated all admin stacks on June 1 2026, creating `spacelift_role_attachment`
resources that are not yet in Terraform state. Import them before applying to avoid drift.

The import ID format is the **binding ID** from the Spacelift API.

All 58 binding IDs are captured in `.sisyphus/spacelift-role-binding-imports.txt` in the
`infrastructure` repo. For each admin stack, add an import block or run:

```bash
terraform import \
  'module.stacks["<STACK_KEY>"].spacelift_role_attachment.admin[0]' \
  '<BINDING_ID>'
```

Example for `gbl-corp-infrastructure`:
```bash
terraform import \
  'module.stacks["gbl-corp-infrastructure"].spacelift_role_attachment.admin[0]' \
  '01KT1DPFWDTGG9SBYZ0Q6JBQBH'
```

---

## Order of operations

**CRITICAL: Follow this order to avoid permission outages.**

1. Run `terraform state mv` commands for all resource renames
2. Run `terraform import` for all 58 role attachments
3. Run `terraform plan` — verify: no unexpected destroys, role attachments show as `no changes`
4. Merge PR and let Spacelift autodeploy apply
5. Verify admin stacks complete a tracked run successfully
6. Remove `administrative: true` from atmos stack YAML catalog files

---

## Atmos YAML changes

Remove `administrative: true` from catalog files:

**`stacks/catalog/spacelift/defaults.yaml`** and **`stacks/catalog/spacelift/policy/defaults.yaml`**:

```yaml
# Before
vars:
  settings:
    spacelift:
      administrative: true   # ← remove this line

# After
vars:
  settings:
    spacelift: {}
```

The `var.administrative` input to the module still controls whether a `spacelift_role_attachment`
is created — the YAML flag just sets the default. You can set `administrative = true` directly
on the module call if all managed stacks should be admin stacks.

---

## Rego policy updates

No Rego policies in this repository reference `stack.administrative`. If you have custom
policies in your infrastructure repo that check `stack.administrative == true`, update them:

```rego
# Before
stack.administrative == true

# After
some role in input.stack.roles
role.id == "space-admin"
```

---

## One space per stack (1-space-per-stack refactor)

This module version adds support for creating a dedicated Spacelift space for every managed stack,
giving each stack independent access control and self-management capability.

### New root variables

| Variable | Type | Default | Description |
|---|---|---|---|
| `stacks_dedicated_space_enabled` | `bool` | `false` | Create a dedicated `spacelift_space` for every managed stack. Set to `true` in `catalog/spacelift/defaults.yaml` to enable globally. Overridable per-stack via `settings.spacelift.dedicated_space_enabled`. |
| `stacks_self_admin_enabled` | `bool` | `false` | Attach `space-admin` role to each managed stack in its own dedicated space. Requires `stacks_dedicated_space_enabled = true`. Overridable per-stack via `settings.spacelift.administrative`. |
| `stacks_inherit_entities` | `bool` | `true` | Whether managed stack dedicated spaces inherit worker pools and contexts from their parent space. Overridable per-stack via `settings.spacelift.inherit_entities`. |
| `write_login_access_github_teams` | `list(string)` | `[]` | GitHub teams granted write access to all dedicated spaces (encoded as `write_access_github_team:<team>` labels). Overridable per-stack via `settings.spacelift.write_login_access_github_teams`. |
| `admin_login_access_github_teams` | `list(string)` | `[]` | GitHub teams granted admin access to all dedicated spaces (encoded as `admin_access_github_team:<team>` labels). Overridable per-stack via `settings.spacelift.admin_login_access_github_teams`. |

### `space_name` default change

`space_name` for dedicated spaces now defaults to the Spacelift **stack name** (e.g. `guests-ue1-prod`) instead of `component_name` (e.g. `spoton-app`). This ensures uniqueness across stacks. Override per-stack via `settings.spacelift.space_name`.

### Enabling globally in `stacks/catalog/spacelift/defaults.yaml`

```yaml
vars:
  stacks_dedicated_space_enabled: true
  stacks_self_admin_enabled: true
  stacks_inherit_entities: true
```

The `write_login_access_github_teams` and `admin_login_access_github_teams` values are inherited from the admin stack's existing `_spacelift-space.yaml` vars — no per-stack YAML changes required.

### Login policy update

The `template-rego-policies/login.github.rego` template now includes label-based `space_write` / `space_admin` rules that match `write_access_github_team:<team>` and `admin_access_github_team:<team>` labels on dedicated spaces. The existing single login policy covers all dedicated spaces with no extra policies needed.

### Validation

Setting `stacks_self_admin_enabled = true` without `stacks_dedicated_space_enabled = true` will fail with:

```
Error: Resource precondition failed
administrative = true requires dedicated_space_enabled = true to scope the space-admin role to the stack's own dedicated space.
```

### No state migration required

Managed stacks have no pre-existing dedicated spaces. Terraform creates them fresh. The `space_id` attribute change on existing stacks is an in-place update (no ForceNew) — run history is preserved.

---

## Rollback procedure

If something goes wrong after applying:

1. The `spacelift_role_attachment` resources already existed before this migration (Spacelift
   auto-created them). Removing them from state does not delete the actual role binding.
2. To roll back the module version: revert the `source` ref in `infrastructure/components/terraform/spacelift/main.tf`
   to `?ref=handle-root-stacks`.
3. The role attachments in Spacelift remain in place regardless — they were auto-migrated by
   Spacelift and are not managed by the old module version.
