output "load_balancer_dns" {
  value = aws_lb.web_app_lb.dns_name
}

output "private_key" {
  value     = tls_private_key.web_app_key.private_key_pem
  sensitive = true
}
