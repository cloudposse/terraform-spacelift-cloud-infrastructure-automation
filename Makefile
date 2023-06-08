SHELL := /bin/bash

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .build-harness "https://cloudposse.tools/build-harness"; echo .build-harness)

## Lint terraform code
lint:
	$(SELF) terraform/install terraform/get-modules terraform/get-plugins terraform/lint terraform/validate


.PHONY: readme
readme:
	$(MAKE) -C modules/spacelift-policy $@
	$(MAKE) -C modules/spacelift-space $@
	$(MAKE) -C modules/spacelift-stack $@
	$(MAKE) -C modules/spacelift-stacks-from-atmos-config $@
	$(MAKE) -f .build-harness $@

.PHONY: docs/targets.md
docs/targets.md:
	$(MAKE) -C modules/spacelift-policy $@
	$(MAKE) -C modules/spacelift-space $@
	$(MAKE) -C modules/spacelift-stack $@
	$(MAKE) -C modules/spacelift-stacks-from-atmos-config $@
	$(MAKE) -f .build-harness $@

.PHONY: docs/terraform.md
docs/terraform.md:
	$(MAKE) -C modules/spacelift-policy $@
	$(MAKE) -C modules/spacelift-space $@
	$(MAKE) -C modules/spacelift-stack $@
	$(MAKE) -C modules/spacelift-stacks-from-atmos-config $@
	$(MAKE) -f .build-harness $@
