package test

import (
	"errors"
	"math/rand"
	"reflect"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func Keys(v interface{}) ([]string, error) {
	rv := reflect.ValueOf(v)
	if rv.Kind() != reflect.Map {
		return nil, errors.New("not a map")
	}
	t := rv.Type()
	if t.Key().Kind() != reflect.String {
		return nil, errors.New("not string key")
	}
	var result []string
	for _, kv := range rv.MapKeys() {
		result = append(result, kv.String())
	}
	return result, nil
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesSpaceliftConfigFromAtmosConfig(t *testing.T) {
	t.Parallel()

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/spacelift-config-from-atmos-config",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.tfvars"},

		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
		SetVarsAfterVarFiles: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	var stacksOutput interface{}

	terraform.OutputStruct(t, terraformOptions, "spacelift_stacks", &stacksOutput)

	stacks := stacksOutput.(map[string]interface{})
	keys, err := Keys(stacks)

	assert.NoError(t, err)

	expectedStackNames := []string{"tenant1-ue2-dev-infra-vpc2", "tenant1-ue2-dev-test-test-component", "tenant1-ue2-dev-test-test-component-override", "tenant1-ue2-dev-top-level-component1"}

	// Verify we're getting back the outputs we expect
	assert.Contains(t, keys, expectedStackNames)
}
