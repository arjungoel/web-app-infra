resource "aws_security_group" "client_alb" {
  name        = "${var.default_tags.project_name}-alb"
  description = "security group for web application load balancer"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.default_tags.project_name}-sg"
  }
}

resource "aws_security_group_rule" "client_alb_allow_80" {
  security_group_id = aws_security_group.client_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "client_alb_allow_22" {
  security_group_id = aws_security_group.client_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow SSH Login."
}

resource "aws_security_group_rule" "client_alb_allow_443" {
  security_group_id = aws_security_group.client_alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow HTTP traffic."
}

resource "aws_security_group_rule" "client_alb_allow_outbound" {
  security_group_id = aws_security_group.client_alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  description       = "Allow any outbound traffic."
}


resource "aws_security_group" "ec2_security_group" {
  name        = "${var.default_tags.project_name}-ec2"
  description = "Security group for EC2 instances in the target group"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.default_tags.project_name}-ec2-sg"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.client_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
