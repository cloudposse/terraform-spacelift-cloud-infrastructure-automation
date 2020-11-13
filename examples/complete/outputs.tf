output "environments" {
    value = [
        for k, v in module.example : v
    ]
}
