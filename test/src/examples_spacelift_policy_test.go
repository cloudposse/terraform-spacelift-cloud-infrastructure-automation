package test

import (
	"fmt"
	"math/rand"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesSpaceliftPolicy(t *testing.T) {
	t.Parallel()

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	// name is here more as an example rather than as a useful test input
	inline_policy_name := fmt.Sprintf("Test Inline Policy %s", randId)
	catalog_policy_name := fmt.Sprintf("Test Catalog Policy %s", randId)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/spacelift-policy",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.tfvars"},

		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes":          attributes,
			"inline_policy_name":  inline_policy_name,
			"catalog_policy_name": catalog_policy_name,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	var inlineOutput interface{}
	var catalogOutput interface{}

	terraform.OutputStruct(t, terraformOptions, "inline_policy", &inlineOutput)
	inline_policy_output := inlineOutput.(map[string]interface{})

	terraform.OutputStruct(t, terraformOptions, "catalog_policy", &catalogOutput)
	catalog_policy_output := catalogOutput.(map[string]interface{})

	// Verify we're getting back the outputs we expect
	assert.Equal(t, "PLAN", inline_policy_output["type"])
	assert.Equal(t, "GIT_PUSH", catalog_policy_output["type"])

	assert.Equal(t, inline_policy_name, inline_policy_output["name"])
	assert.Equal(t, catalog_policy_name, catalog_policy_output["name"])
}
