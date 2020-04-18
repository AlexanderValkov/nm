resource "aws_security_group" "elb" {
  name        = "elb"
  description = "ELB"
  vpc_id      = aws_vpc.nm.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_from]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allow_from]
    description = "HTTPS"
  }
}

resource "aws_security_group" "ecs_service" {
  name        = "ecs_service"
  description = "ECS Service"
  vpc_id      = aws_vpc.nm.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.elb.id]
    description = "ELB Incoming"
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access to the Internet"
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access to the Internet"
  }
}


resource "aws_security_group_rule" "elb_egress_to_ecs_service" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.ecs_service.id
  security_group_id = aws_security_group.elb.id
  description       = "ECS Service"
}

