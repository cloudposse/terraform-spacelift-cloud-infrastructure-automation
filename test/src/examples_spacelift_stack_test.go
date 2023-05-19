package test

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesSpaceliftStack(t *testing.T) {
	t.Parallel()

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	stack_name := fmt.Sprintf("Test Space %s", randId)
	expected_slug := strings.ReplaceAll(strings.ToLower(stack_name), " ", "-")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/spacelift-stack",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.tfvars"},

		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
			"stack_name": stack_name,
		},
		SetVarsAfterVarFiles: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	var stackIdOutput interface{}

	terraform.OutputStruct(t, terraformOptions, "stack_id", &stackIdOutput)
	stackId := stackIdOutput.(string)

	// Verify we're getting back the outputs we expect
	assert.Equal(t, expected_slug, stackId)
}
