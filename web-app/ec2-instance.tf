resource "aws_instance" "web_app" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.0.id
  vpc_security_group_ids = [aws_security_group.client_alb.id]
  user_data              = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo '<center><h1>Web App!!!</h1></center>' > /var/www/html/index.html
EOF
  tags = {
    Name = "${var.default_tags.project_name}-ec2-instance"
  }
  key_name                    = var.generated_key_name
  associate_public_ip_address = true
  monitoring                  = true
}

// Create key-pair for EC2 instance

resource "tls_private_key" "web_app_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.web_app_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${local.ssh_key_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.web_app_key.private_key_pem
  provisioner "local-exec" {
    command = <<-EOT
      touch ec2-keypair.pem
      cp "~/.ssh/${local.ssh_key_name}.pem" ./ec2-keypair.pem
      chmod 400 ec2-keypair.pem
    EOT
  }
}
