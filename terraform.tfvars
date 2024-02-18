region     = "us-east-1"
role_arn   = "arn:aws:iam::123758214167:role/aws-terraform-assignment-role"
cidr_block = "10.255.0.0/20"
default_tags = {
  primary_owner   = "Arjun Goel"
  secondary_owner = "Arjun Goel"
  project_name    = "web-app-infra"
}
public_subnet_count  = 2
private_subnet_count = 2
instance_type        = "t2.micro"
generated_key_name   = "web-app-assignment-key"
health_check = {
  timeout             = "5"
  interval            = "30"
  path                = "/"
  unhealthy_threshold = "2"
  healthy_threshold   = "5"
}
