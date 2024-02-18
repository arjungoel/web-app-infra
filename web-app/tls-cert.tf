resource "tls_self_signed_cert" "self_signed" {
  #   key_algorithm   = tls_private_key.web_app_key.algorithm
  private_key_pem = tls_private_key.web_app_key.private_key_pem
  subject {
    common_name = "test.example.com"
  }
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  dns_names = ["test.example.com"]
}
