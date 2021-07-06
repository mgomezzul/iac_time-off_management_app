resource "random_id" "sg" {
  byte_length = 8
}

resource "aws_security_group" "default" {
  count       = var.load_balancer_type == "application" ? 1 : 0
  name        = "allow_ALB_listener_${random_id.sg.dec}_traffic"
  description = "allow_ALB_listener_traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}