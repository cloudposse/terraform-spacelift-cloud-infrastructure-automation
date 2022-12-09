# https://spacelift.io/changelog/en/changing-the-default-stack-push-behavior
package spacelift

track {
  input.push.branch = input.stack.branch
}

propose { true }
